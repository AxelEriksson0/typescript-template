# Traefik infrastructure

https://doc.traefik.io/traefik/ - Traefik is an open-source Application Proxy that makes publishing your services a fun and easy experience. It receives requests on behalf of your system and identifies which components are responsible for handling them, and routes them securely.

## Install

You need to have `podman` and `podman-compose` installed.

- Create Podman network: `podman network create traefik-network`
- `podman-compose up -d`
- systemctl --user enable --now podman.socket
- sudo sysctl -w net.ipv4.ip_unprivileged_port_start=80

## Future
I will look into using `Quadlets` over `podman-compose`.