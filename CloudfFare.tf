provider "cloudflare" {
  api_key = var.cloudflare_api_key
  email = var.cloudflare_email
}

data "cloudflare_zone" "zone" {
  name = var.domain_name
}

resource "cloudflare_record" "vpn" {
  name    = var.vpn_subdomain
  value   = digitalocean_droplet.vpn-server.ipv4_address
  type    = "A"
  proxied = false
  zone_id = data.cloudflare_zone.zone.id
  depends_on = [
    digitalocean_droplet.vpn-server
  ]
}