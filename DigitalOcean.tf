provider "digitalocean" {
  token = var.digitalocean_api_token
}

resource "digitalocean_droplet" "vpn-server" {
  ssh_keys  = [
    for ssh_key in data.digitalocean_ssh_keys.keys.ssh_keys : ssh_key.id
  ]
  image     = var.image
  region    = var.network_location
  size      = "s-1vcpu-1gb"
  backups   = false
  ipv6      = false
  name      = "${var.vpn_subdomain}.${var.domain_name}"
  user_data = <<-EOF
    #cloud-config
    hostname: ${var.vpn_subdomain}.${var.domain_name}
    fqdn: ${var.vpn_subdomain}.${var.domain_name}
    runcmd:
        - echo 'yum -y install https://as-repository.openvpn.net/as-repo-centos7.rpm && yum -y install openvpn-as git nano && systemctl enable openvpnas' >> /root/install.sh
        - echo 'git clone https://github.com/acmesh-official/acme.sh.git /root/acme.sh' >> /root/install.sh
        - echo 'cd /root/acme.sh' >> /root/install.sh
        - echo "sh acme.sh --install -m ${var.cloudflare_email}" >> /root/install.sh
        - echo 'echo "export CF_Key=${var.cloudflare_api_key}" >> /root/.acme.sh/account.conf' >> /root/install.sh
        - echo 'echo "export CF_Email=${var.cloudflare_email}" >> /root/.acme.sh/account.conf' >> /root/install.sh
        - echo 'echo "export SAVED_CF_Key=${var.cloudflare_api_key}" >> /root/.acme.sh/account.conf' >> /root/install.sh
        - echo 'echo "export SAVED_CF_Email=${var.cloudflare_email}" >> /root/.acme.sh/account.conf' >> /root/install.sh
        - echo 'sh /root/.acme.sh/acme.sh --issue -d "${var.domain_name}" -d "*.${var.domain_name}" -k 4096 --dns dns_cf --server https://acme-v02.api.letsencrypt.org/directory --force' >> /root/install.sh
        - echo '/usr/local/openvpn_as/scripts/confdba -mk cs.ca_bundle -v "`cat /root/.acme.sh/${var.domain_name}/ca.cer`" > /dev/null' >> /root/install.sh
        - echo '/usr/local/openvpn_as/scripts/confdba -mk cs.priv_key -v "`cat /root/.acme.sh/${var.domain_name}/${var.domain_name}.key`" > /dev/null' >> /root/install.sh
        - echo '/usr/local/openvpn_as/scripts/confdba -mk cs.cert -v "`cat /root/.acme.sh/${var.domain_name}/${var.domain_name}.cer`" > /dev/null' >> /root/install.sh
        - echo "/usr/local/openvpn_as/scripts/sacli --user 'openvpn' --new_pass '${var.openvpn_password}' SetLocalPassword" >> /root/install.sh
        - echo '/usr/local/openvpn_as/scripts/sacli -k "host.name" -v "${var.vpn_subdomain}.${var.domain_name}" configPut' >> /root/install.sh
        - echo 'systemctl restart openvpnas' >> /root/install.sh
        - echo 'nameserver 94.140.14.14' > /etc/resolv.conf
        - echo 'nameserver 94.140.14.15' >> /etc/resolv.conf
    EOF

  connection {
    host        = self.ipv4_address
    type        = "ssh"
    private_key = file("~/.ssh/id_rsa")
    user        = "root"
    timeout     = "2m"
  }
}

data "digitalocean_ssh_keys" "keys" {

}