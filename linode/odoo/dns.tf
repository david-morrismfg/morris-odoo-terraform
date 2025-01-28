data "cloudflare_zone" "morriserp" {
  name = var.domain
}
# data "cloudflare_zone" "morriserp_dev" {
#   name = "morriserp.dev"
# }

resource "cloudflare_record" "odoo" {
  zone_id = data.cloudflare_zone.morriserp.id
  name    = "@"
  content   = linode_instance.odoo.ip_address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "odoo_host" {
  zone_id = data.cloudflare_zone.morriserp.id
  name    = "odoo"
  content   = linode_instance.odoo.ip_address
  type    = "A"
  proxied = false
}

# resource "cloudflare_record" "odoo_dev" {
#   zone_id = data.cloudflare_zone.morriserp_dev.id
#   name    = "@"
#   content   = linode_instance.odoo.ip_address
#   type    = "A"
#   proxied = true
# }
