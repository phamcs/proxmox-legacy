resource "proxmox_vm_qemu" "jammy" {
  count = 3
  name = var.hostnames[count.index]
  target_node = var.proxmox_host

  clone = var.template_name
  vmid = var.vmid + count.index
  agent = 1
  agent_timeout = 600
  os_type = "cloud-init"
  cpu { cores = 4 }
  #sockets = 1
  #cpu = "host"
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
  ipconfig0 = "ip=${var.ips[count.index]}/24,gw=${cidrhost(format("%s/24", var.ips[count.index]), 1)}"
  #ipconfig0 = "ip=dhcp"
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
          size = "10G"
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
      host = var.ips[count.index]
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
      command = "ansible-playbook -u ${var.user} --key-file ${var.ssh_keys["priv"]} -i ${var.ips[count.index]}, provision.yaml"
  }

  #provisioner "local-exec" {
  #    working_dir = "../../../ansible/"
  #    command = "ansible-playbook -u ${var.user} --key-file ${var.ssh_keys["priv"]} -i ${var.ips[count.index]}, extras.yaml"
  #}
}
