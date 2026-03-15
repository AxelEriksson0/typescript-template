# Traefik infrastructure

https://doc.traefik.io/traefik/ - Traefik is an open-source Application Proxy that makes publishing your services a fun and easy experience. It receives requests on behalf of your system and identifies which components are responsible for handling them, and routes them securely.

We are using Quadlet to manage the Traefik container.

## Deploy

```bash
./deploy.sh <user@host> <domain> <email>
```

Example:

```bash
./deploy.sh root@1.2.3.4 example.com admin@example.com
```

This copies all Quadlet files to the server, substitutes the ACME email, initialises `acme.json`, and starts the service. TLS certificates for `<domain>` are issued automatically by Let's Encrypt on the first HTTPS request.

## Server prerequisites

These need to be run once on the server before deploying.

### Enable Podman socket

`enable` instead of `start` makes sure it starts on boot.

```bash
systemctl --user enable --now podman.socket
```

### Enable unprivileged ports

Podman doesn't allow ports below 1024 by default.

```bash
sudo sysctl -w net.ipv4.ip_unprivileged_port_start=80
```
