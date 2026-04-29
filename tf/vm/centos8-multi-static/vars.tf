variable "api_url" {
    # The Proxmox Web UI address, with /api2/json added to it.
    default = "https://10.0.0.33:8006/api2/json"
}

variable "proxmox_host" {
    # The name of the Proxmox server listed under Datacenter
    default = "SERVER-3"
}

variable "template_name" {
  default = "centos8-tpl"
}

variable "vault_address" {
  default = "https://vault.superasian.net"
}

variable "vault_token" {}

variable "hostnames" {
  description = "Containers to be created"
  type        = list(string)
  default     = ["prod-centos", "test-centos", "dev-centos"]
}

variable "ips" {
    description = "IPs of the VMs, respective to the hostname order"
    type        = list(string)
	  default     = ["10.0.0.60", "10.0.0.61", "10.0.0.62"]
}

variable "vmid" {
	default     = 2000
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
	default     = "centos"
	description = "User used to SSH into the machine and provision it"
}
