variable "api_url" {
    # The Proxmox Web UI address, with /api2/json added to it.
    default = "https://10.0.0.25:8006/api2/json"
}

variable "proxmox_host" {
    # The name of the Proxmox server listed under Datacenter
    default = "SERVER-1"
}

variable "template_name" {
  default = "jammy-tpl"
}

variable "vault_address" {
  default = "https://vault.superasian.net"
}

variable "vault_token" {}

variable "vmid" {
	default     = 1000
	description = "Starting ID for the VMs"
}

variable "ssh_keys" {
	type = map
      default = {
        pub  = "~/.ssh/id_ed25519.pub"
        priv = "~/.ssh/id_ed25519"
      }
}

variable "user" {
	default     = "ubuntu"
	description = "User used to SSH into the machine and provision it"
}
