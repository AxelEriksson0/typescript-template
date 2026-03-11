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

## Services

Services are deployed post-boot using scripts in the `services/` directory. The base image is not modified.

### Deploy a service

```bash
./services/deploy.sh <service> <user@host> [install-args...]
```

### Joplin

Joplin Server — a self-hosted note-taking sync server.

```bash
./services/deploy.sh joplin root@<server-ip> <server-ip>
```

Access at `https://<server-ip>/joplin`

Default credentials:
- **Email:** `admin@localhost`
- **Password:** `admin`

You will be prompted to change the password on first login.

Data is persisted in the `joplin-data` Podman volume at:
`/root/.local/share/containers/storage/volumes/joplin-data/_data/`
