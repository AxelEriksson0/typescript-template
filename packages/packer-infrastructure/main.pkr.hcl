packer {
  required_plugins {
    hcloud = {
      source  = "github.com/hetznercloud/hcloud"
      version = ">= 1.7.0"
    }
  }
}

source "hcloud" "image" {
  firewalls     = ["firewall-1"]
  image         = var.base_image
  location      = "hel1" # Helsinki
  server_type   = "cx23" # Shared compute resource
  snapshot_labels = {
    base    = var.base_image,
    version = var.version,
    name    = "${var.output_name}-${var.version}"
  }
  snapshot_name = "${var.output_name}-${var.version}"
  ssh_keys      = var.ssh_keys
  ssh_username  = "root"
  user_data     = file(var.user_data_path)
}

build {
  sources = ["source.hcloud.image"]
  provisioner "shell" {
    scripts = [
      "setup.sh",
    ]
    env = {
      BUILDER = "packer"
    }
  }
}