terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

# Authenticate using token (simplest method)
provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}

# Read from Vault
data "vault_kv_secret_v2" "proxmox" {
  mount = "secret"
  name  = "proxmox"
}

provider "proxmox" {
  pm_api_url          = var.api_url
  pm_api_token_id     = data.vault_kv_secret_v2.proxmox.data["token_id"]
  pm_api_token_secret = data.vault_kv_secret_v2.proxmox.data["token_secret"]
  pm_log_enable       = false
  pm_log_file         = "terraform-plugin-proxmox.log"
  pm_parallel         = 1
  pm_timeout          = 600
  pm_tls_insecure     = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}
