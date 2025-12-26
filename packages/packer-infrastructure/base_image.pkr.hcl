source "hcloud" "base-amd64" {
  image         = "debian-12"
  location      = "nbg1"
  server_type   = "cx23"
  ssh_keys      = []
  user_data     = ""
  ssh_username  = "root"
  snapshot_name = "custom-img"
  snapshot_labels = {
    base    = "debian-12",
    version = "v1.0.0",
    name    = "custom-img"
  }
}

build {
  sources = ["source.hcloud.base-amd64"]
  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install -y wget fail2ban cowsay",
      "/usr/games/cowsay 'Hi Hetzner Cloud' > /etc/motd",
    ]
    env = {
      BUILDER = "packer"
    }
  }
}