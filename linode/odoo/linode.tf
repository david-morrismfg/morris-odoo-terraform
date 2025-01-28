resource "linode_instance" "odoo" {
  label     = "odoo"
  image     = "linode/ubuntu22.04"
  region    = "us-ord"
  type      = "g6-dedicated-4"
  authorized_keys = [replace(file(var.pub_key), "\n", "")]
  root_pass = var.root_password

  # Enable safety features
  watchdog_enabled = true
  backups_enabled  = false

  # Basic monitoring alerts
  alerts {
    cpu            = 90
    io             = 10000
    network_in     = 10
    network_out    = 10
    transfer_quota = 80
  }

  # Define network interfaces
  interface {
    purpose = "public"
    primary = true
  }

  interface {
    purpose = "vpc"
    subnet_id = linode_vpc_subnet.odoo.id
    ipv4 {
      vpc = "10.0.4.250"
    }
  }

  # Management tags
  tags = ["production", "odoo", "erp"]

  timeouts {
    create = "30m"
    update = "30m"
    delete = "10m"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]

    connection {
      host        = self.ip_address
      type        = "ssh"
      user        = "root"
      private_key = file(var.pvt_key)
    }
  }
}

resource "linode_volume" "odoo_data" {
  label     = "odoo-data"
  size      = 50
  region    = "us-ord"
  linode_id = linode_instance.odoo.id
  tags      = ["production", "odoo", "erp"]

  encryption = "disabled"

  timeouts {
    create = "10m"
    update = "20m"
    delete = "10m"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.pvt_key)
      host        = linode_instance.odoo.ip_address
    }

    inline = [
      # Create mount point
      "mkdir -p ${var.odoo_path}",
      "mkfs.ext4 /dev/disk/by-id/scsi-0Linode_Volume_${self.label}",
      "mount /dev/disk/by-id/scsi-0Linode_Volume_${self.label} ${var.odoo_path}",
      "echo '/dev/disk/by-id/scsi-0Linode_Volume_${self.label} ${var.odoo_path} ext4 defaults 0 0' >> /etc/fstab",
      "chown root:root ${var.odoo_path}",
      "chmod 755 ${var.odoo_path}"
    ]
  }
}

# VPC Network Configuration
resource "linode_vpc" "odoo" {
  label       = "odoo-vpc"
  region      = "us-ord"
  description = "VPC for Odoo ERP deployment"
}

resource "linode_vpc_subnet" "odoo" {
  vpc_id = linode_vpc.odoo.id
  label  = "odoo-subnet"
  ipv4   = "10.0.4.0/24"
}