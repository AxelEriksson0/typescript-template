# Packer infrastructure

Packer is an Infrastructure as Code (IaC) tool for creating custom machine images.

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

## Build

### Set your Hetzner API Token
export HCLOUD_TOKEN="XXX"

### Initialize the project - only needed once
packer init .

### Build
packer build .