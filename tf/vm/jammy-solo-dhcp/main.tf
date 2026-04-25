terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.api_url
  pm_api_token_id     = var.token_id
  pm_api_token_secret = var.token_secret
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
