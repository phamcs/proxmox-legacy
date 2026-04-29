variable "api_url" {
    # The Proxmox Web UI address, with /api2/json added to it.
    default = "https://10.0.0.33:8006/api2/json"
}

variable "proxmox_host" {
    # The name of the Proxmox server listed under Datacenter
    default = "SERVER-3"
}

variable "vault_address" {
  default = "https://vault.superasian.net"
}

variable "vault_token" {}

variable "vmid" {
	default     = 500
	description = "Starting ID for the CTs"
}

variable "hostnames" {
  description = "Containers to be created"
  type        = list(string)
  default     = ["prod-ct", "test-ct", "dev-ct"]
}

variable "rootfs_size" {
	description = "Root filesystem size in GB"
	default = "10G"
}

variable "ips" {
    description = "IPs of the containers, respective to the hostname order"
    type        = list(string)
	default     = ["10.0.0.41", "10.0.0.42", "10.0.0.43"]
}

variable "user" {
	default     = "root"
	description = "Ansible user used to provision the container"
}

variable "ssh_keys" {
	type = map
     default = {
       pub = "~/.ssh/id_ed25519.pub"
       priv = "~/.ssh/id_ed25519"
     }
}