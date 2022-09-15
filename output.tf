output "IPv4" {
  value = digitalocean_droplet.vpn-server.ipv4_address
}

output "vpn-server-hostname" {
  value = "${var.vpn_subdomain}.${var.domain_name}"
}

output "vpn-password"{
  value = var.openvpn_password
}