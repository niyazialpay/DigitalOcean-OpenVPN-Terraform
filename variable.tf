variable "vpn_subdomain" {
  default = "vpn-test"
}

variable "ssh_key_path" {
  type        = string
  description = "The file path to an ssh public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "network_location"{
  default = "nyc1"
}

variable "image" {
  default     = "ubuntu-22-04-x64"
}
