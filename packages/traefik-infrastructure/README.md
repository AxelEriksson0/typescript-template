# Traefik infrastructure

https://doc.traefik.io/traefik/ - Traefik is an open-source Application Proxy that makes publishing your services a fun and easy experience. It receives requests on behalf of your system and identifies which components are responsible for handling them, and routes them securely.

We are using Quadlet to manage the Traefik container.

## Install

You need to have `podman` installed.

### Create Podman network
- `podman network create traefik-network`

### Enable Podman socket
enable instead of start makes sure it starts on boot.
- `systemctl --user enable --now podman.socket`

### Enable IP unprivileged ports
Podman doesn't allow ports below 1024 by default.
- `sudo sysctl -w net.ipv4.ip_unprivileged_port_start=80`

Move the Quadlet files (traefik.yml, traefik.container and traefik.network) to the correct location:
- ~/.config/containers/systemd/

- `systemctl --user daemon-reload`
- `systemctl --user start traefik.service`
- `systemctl --user start traefik.network`