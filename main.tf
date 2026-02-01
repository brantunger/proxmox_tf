terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}


provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = true
}


resource "proxmox_lxc" "test-container" {
  count        = var.lxc_count
  hostname     = "LXC-test-${count.index + 1}"
  target_node  = var.node_name
  vmid         = 1000 + count.index # Ensure unique VMIDs
  ostemplate   = "local:vztmpl/${var.lxc_template}"
  cores        = var.lxc_cores
  memory       = var.lxc_memory
  password     = var.lxc_password
  unprivileged = true
  onboot       = true
  start        = true

  rootfs {
    storage = "local-lvm"
    size    = "2G"
  }

  features {
    nesting = true
  }
  
  network {
     name   = "eth0"
     bridge = "vmbr0"
     ip     = "dhcp"
     type   = "veth"
  }
}