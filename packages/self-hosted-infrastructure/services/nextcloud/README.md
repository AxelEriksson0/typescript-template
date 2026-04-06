# Nextcloud All-in-One

Nextcloud AIO deployed as a Podman Quadlet systemd user service, behind Traefik.

## Installation

```bash
./install.sh <host>
# Example: ./install.sh nextcloud.example.com
```

Then complete setup at `https://<host>/login`. The initial passphrase is printed in the container logs or can be read with:

```bash
podman exec nextcloud-aio-mastercontainer cat /mnt/docker-aio-config/data/configuration.json
```

Before completing the setup wizard, create the backup directory on the server:

```bash
ssh root@<server-ip> "mkdir -p /mnt/nextcloud_backup"
```

Enter `/mnt/nextcloud_backup` as the backup location in the wizard, then enable **Nextcloud Office (Collabora)** under Optional Containers to activate the built-in CODE server.

## Known issues and workarounds

### Container must be named exactly `nextcloud-aio-mastercontainer`
AIO checks its own container name on startup and refuses to run with any other name.
`ContainerName=nextcloud-aio-mastercontainer` is required in the Quadlet file.

### AIO requires a dedicated subdomain
AIO cannot run under a path prefix (e.g. `a54l.se/nextcloud`). It must own the root of a domain.

### `serversTransports` cannot be defined via Docker labels
Traefik does not support defining `serversTransports` through Docker provider labels. The `aio-insecure` transport label will be silently ignored and the router disabled with an error. The workaround is to add `insecureSkipVerify: true` globally to Traefik's static config (`traefik.yml`):

```yaml
serversTransport:
  insecureSkipVerify: true
```

This is needed because the AIO management UI serves HTTPS with a self-signed certificate.

### Domain validation fails behind Cloudflare proxy
AIO tries to validate that the domain points directly to the server. When the DNS record goes through Cloudflare's proxy (orange cloud), this check fails. `SKIP_DOMAIN_VALIDATION=true` bypasses it.

### Traefik 3.6.4+ breaks Collabora WebSocket connections

Traefik 3.6.4 changed URL encoding handling in a way that breaks the WebSocket connections Collabora (Nextcloud Office) uses for document editing. The fix is to allow encoded characters on the `websecure` entrypoint in `traefik.yml`:

```yaml
entryPoints:
  websecure:
    http:
      encodedCharacters:
        allowEncodedSlash: true
        allowEncodedQuestionMark: true
        allowEncodedPercent: true
```

Reference: https://www.reddit.com/r/NextCloud/comments/1lih9r1/traefik_v364_breaks_nextcloud_officecollabora/

This is already applied in [traefik.yml](../../../traefik-infrastructure/traefik.yml).

### Port conflicts on this server
- Port `8080` — taken by Traefik's dashboard entrypoint
- Port `8888` — taken by MediaMTX

The AIO management UI (internal port 8080) is routed through Traefik rather than published directly to avoid these conflicts.
