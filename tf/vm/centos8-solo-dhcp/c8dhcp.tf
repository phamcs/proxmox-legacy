resource "proxmox_vm_qemu" "centos8" {
  count = 1
  name = "centos8"
  target_node = var.proxmox_host

  clone = var.template_name
  vmid = var.vmid
  agent = 1
  agent_timeout = 600
  os_type = "cloud-init"
  cpu {
    cores = 4
    sockets = 1
  }
  memory = 2048
  serial {
    id   = 0
    type = "socket"
  }
  vga {
    type = "serial0"
  }
  scsihw = "virtio-scsi-single"
  bootdisk = "scsi0"
  ipconfig0 = "ip=dhcp"
  sshkeys = file(var.ssh_keys["pub"])

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          backup = true
          cache = "none"
          discard = true
          iothread = false
          replicate = false
          size = "20G"
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id = 0
    bridge = "vmbr0"
    firewall = false
    link_down = false
    model = "virtio"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  provisioner "remote-exec" {
    #creates ssh connection to check when the CT is ready for ansible provisioning
    connection {
      type = "ssh"
      port = 22
      host = self.ssh_host
      user = var.user
      private_key = file(var.ssh_keys["priv"])
      agent = false
      timeout = "3m"
    }
	  # Leave this here so we know when to start with Ansible local-exec
    inline = [ "echo 'Cool, we are ready for provisioning'"]
  }

  provisioner "local-exec" {
      working_dir = "../../../ansible/"
      command = "ansible-playbook -u ${var.user} --key-file ${var.ssh_keys["priv"]} -i ${self.ssh_host}, provision.yaml"
  }
}
