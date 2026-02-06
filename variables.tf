variable "pm_api_url" {
  type = string
}

variable "pm_api_token_id" {
  type = string
}

variable "pm_api_token_secret" {
  type      = string
  sensitive = true
}

variable "node_name" {
  type    = string
  default = "pve1"
}

variable "lxc_template" {
  type    = string
  default = "debian-13-standard_13.1-2_amd64.tar.zst"
  # default = "ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst"
}

variable "lxc_storage" {
  type    = string
  default = "local-lvm"
}

variable "lxc_password" {
  type      = string
  default   = "password"
  sensitive = true
}

variable "lxc_memory" {
  type    = number
  default = 384
}

variable "lxc_swap" {
  type    = number
  default = 512
}

variable "lxc_cores" {
  type    = number
  default = 2
}

variable "lxc_count" {
  type    = number
  default = 1
}

variable "ssh_public_key_file" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "network_gateway" {
  type    = string
  default = "192.168.68.1"
}

variable "network_cidr" {
  type    = string
  default = "192.168.68.0/24"
}
