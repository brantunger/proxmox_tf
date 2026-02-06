output "container_ips" {
  value       = [for ip in proxmox_lxc.test-container[*].network[0].ip : split("/", ip)[0]]
  description = "The IP addresses of the containers"
}

output "container_hostnames" {
  value       = proxmox_lxc.test-container[*].hostname
  description = "The Hostnames of the containers"
}
