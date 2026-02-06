resource "proxmox_lxc" "test-container" {
  count        = var.lxc_count
  hostname     = "lxc-test-${count.index + 1}"
  target_node  = var.node_name
  vmid         = 100 + count.index
  ostemplate   = "local:vztmpl/${var.lxc_template}"
  cores        = var.lxc_cores
  memory       = var.lxc_memory
  swap         = var.lxc_swap
  password     = var.lxc_password
  unprivileged = true
  onboot       = true
  start        = true

  rootfs {
    storage = var.lxc_storage
    size    = "2G"
  }

  features {
    nesting = true
  }

  ssh_public_keys = file(var.ssh_public_key_file)

  network {
    name   = "eth0"
    bridge = "vmbr0"
    # Calculate IP: 192.168.68.100, .101, etc.
    ip     = "${cidrhost(var.network_cidr, 100 + count.index)}/24"
    gw     = var.network_gateway
    type   = "veth"
  }
}

resource "local_file" "ansible_inventory" {
  content = join("\n", [
    "[proxmox_lxc]",
    join("\n", formatlist("%s ansible_host=%s ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519", 
      proxmox_lxc.test-container[*].hostname, 
      # Extract just the IP from "IP/CIDR" string
      [for ip in proxmox_lxc.test-container[*].network[0].ip : split("/", ip)[0]]
    ))
  ])
  filename = "${path.module}/ansible/inventory.ini"
}

resource "null_resource" "ansible_provisioner" {
  triggers = {
    always_run = timestamp()
    inventory  = local_file.ansible_inventory.content
  }

  provisioner "local-exec" {
    command = "sleep 10 && ansible-playbook -i ${path.module}/ansible/inventory.ini ${path.module}/ansible/playbook.yml"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }

  depends_on = [local_file.ansible_inventory, proxmox_lxc.test-container]
}