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

### Set your Hetzner API Token

export HCLOUD_TOKEN="XXX"

### Build

packer build .

### Build with variables

- `packer build --var 'ssh_keys=["xxx-xxx-xxx"]' .`

### Installing NodeJS

Add `- unzip` to the packages array.
Add `-curl -fsSL https://fnm.vercel.app/install | bash` to the runcmd array.
