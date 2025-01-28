terraform {
  cloud {
    organization = "morrismfg"
    workspaces {
      name = "linode-odoo"
    }
  }
  required_providers {
    linode = {
      source = "linode/linode"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

provider "linode" {
  token = "dd9d6171474a7e841afbada8e1f4c61f502abfdb625ecb3e5c51ef0b9911ac52"
}
provider "cloudflare" {}

provider "github" {
  owner = "morrismfg"
}
