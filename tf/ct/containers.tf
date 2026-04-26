
resource "proxmox_lxc" "basic" {
  count = 3
  hostname = var.hostnames[count.index]
  target_node = var.proxmox_host
  vmid = var.vmid + count.index
  cores = 1
  memory = 2048

  ostemplate = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  ostype = "ubuntu"
  unprivileged = "true"
  start = "true"

  rootfs {
    storage = "local-lvm"
    size = var.rootfs_size
  }
  swap = 0

  # Mountpoints
  mountpoint {
    key = "1"
    slot = 0
    storage = "local-lvm"
    mp = "/srv"
    size = "20G" #this is required
  }

  network {
    ip = format("%s/24", var.ips[count.index])
    name ="eth0"
    bridge = "vmbr0"
    firewall = "false" # this does not work at the moment
    gw = cidrhost(format("%s/24", var.ips[count.index]), 1)
  }

  ssh_public_keys = file(var.ssh_keys["pub"])

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
      working_dir = "../../ansible/"
      command = "ansible-playbook -u ${var.user} --key-file ${var.ssh_keys["priv"]} -i ${var.ips[count.index]}, provision.yaml"
  }
}