variable "domain" {
  default = "morriserp.com"
}

variable "pvt_key" {
  description = "Path to SSH private key"
  default     = "~/.ssh/id_rsa"
}

variable "pub_key" {
  description = "Path to SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "github_pat" {}
variable "odoo_password" {}
variable "root_password" {}
variable "odoo_image" {
  default = "ghcr.io/morrismfg/odoo:16.0.0.1"
}

variable "odoo_path" {
  default = "/odoo"
}
