# Proxmox-legacy

Automations for Proxmox using Terraform and Ansible. This can be used to setup and provision containers and virtual machines. Read [terraform proxmox_vm_qemu](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu) for more information.

### Containers Usage

1. Clone the repo and `cd proxmox-legacy/tf/ct`
2. Install `ansible` and `terraform` (on a Mac `brew install ansible terraform`)
3. Configure the variables in `vars.tf` and add your public keys to `ansible/files/authorized_keys`. To provision multiple resources, add more hostnames and IP addresses to the defined list in `vars.tf`.
4. `terraform init` (this should pull in the Terraform Proxmox provider and configure the Terraform project)
5. `terraform plan -out plan`
6. `terraform apply`

### VMs Usage

1. Clone the repo and `cd proxmox-legacy/tf/vm/jammy-solo` (for single deploy Ubuntu-Jammy)
2. Install `ansible` and `terraform` (on a Mac `brew install ansible terraform`)
3. Configure the variables in `vars.tf` and add your public keys to `ansible/files/authorized_keys`. To provision multiple resources, use the *-multi-static repo and add more hostnames and IP addresses to the defined list in `vars.tf`.
4. `terraform init` (this should pull in the Terraform Proxmox provider and configure the Terraform project)
5. `terraform plan -out plan`
6. `terraform apply`

### Pre-requirememnt for VM by creating a cloud-init VM template

On the pve host:

1. `pick the provide script to build the template of your choice`
2. `Add the cloudinit-config.yml to the snippets directory on your proxmox host`
```
build_jammy_tpl: Build Ubuntu Jammy template
build_centos_tpl: Build CentOS 8 template
```
### TO DO:

~~1.  Need to add code to fetch credentials from vault~~
