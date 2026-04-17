# Server infrastructure

Infrastructure for provisioning and managing servers.

## Install Packer

Fedora:

```
wget -O- https://rpm.releases.hashicorp.com/fedora/hashicorp.repo | sudo tee /etc/yum.repos.d/hashicorp.repo
sudo yum list available | grep hashicorp
sudo dnf -y install packer
```

I use Hetzner as my Cloud provider.

## Getting started

- `packer init .` to initialize the project.

### Set your Hetzner API Token

export HCLOUD_TOKEN="XXX"

### Build

packer build .

### Build with variables

- `packer build --var 'ssh_keys=["xxx-xxx-xxx"]' .`

### Installing NodeJS

Add `- unzip` to the packages array.
Add `-curl -fsSL https://fnm.vercel.app/install | bash` to the runcmd array.

## Hetzner Cloud Firewall

The server uses the Hetzner Cloud Firewall (not OS-level firewall). After provisioning, open ports in the [Hetzner Cloud Console](https://console.hetzner.cloud) → Firewalls → your firewall → Add inbound rule.

Ports required by deployed services:

| Port | Protocol | Service  | Required for             |
| ---- | -------- | -------- | ------------------------ |
| 80   | TCP      | Caddy    | HTTP → HTTPS redirect    |
| 443  | TCP      | Caddy    | HTTPS (all web services) |
| 1935 | TCP      | MediaMTX | RTMP ingest from OBS     |

## Services

See [services/README.md](../self-hosted-infrastructure/services/README.md).

## Raspberry Pi

I haven't figured out how to create IAC for Raspberry Pi so here are the manual steps.

I use a Raspberry Pi 4 Model B, 4GB.

### Raspberry Pi Imager

In order to put software on your SD-card I use Raspberry Pi [Imager](https://www.raspberrypi.org/software/).

- Raspberry Pi OS Lite (64-bit)
- Control + Shift + X to open advanced menu
  - Set hostname: rxtl.local
  - Enable SSH. Allow public-key authentication only. In my case I had a key under ~/.ssh/id_ed25519.pub
  - If you're running on an older Raspberry Pi, it might not support 5GHz band when configuring the WiFi.

### Network

- When using `Raspberry Pi Imager`, the password field of the network can be cached to some old value, even after updating it.
- You need to manually update it in the `network-configuration` on the boot disc.
- You will probably need to mount the disk with write permissions `sudo mount -o remount,rw /run/media/${USER}/boot_image`

### SSH

What you set the username to is the path you SSH into. For example if the username is pi:

```
ssh pi@rxtl.local
```

#### Configure user group to not need root

```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```
