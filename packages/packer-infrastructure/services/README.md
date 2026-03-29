# Services

Services are deployed post-boot using scripts in the `services/` directory. The base image is not modified.

## Deploy a service

```bash
./services/deploy.sh <service> <user@host> [install-args...]
```

## Domain verification

After pointing a domain at the server, verify it with [Google Search Console](https://search.google.com/search-console/welcome) to avoid Chrome's "Dangerous site" warning. Without verification, Google may flag the domain as distributing unwanted software.

If your domain is already flagged, go to **Security & Manual Actions → Security Issues** in Search Console and request a review.

## Joplin

Joplin Server — a self-hosted note-taking sync server.

```bash
./services/deploy.sh joplin root@<server-ip> example.com
```

Access at `https://example.com/joplin`

Default credentials:

- **Email:** `admin@localhost`
- **Password:** `admin`

You will be prompted to change the password on first login.

Data is persisted in the `joplin-data` Podman volume at:
`/root/.local/share/containers/storage/volumes/joplin-data/_data/`

## NextCloud

NextCloud — a self-hosted file sync and sharing platform.

```bash
./services/deploy.sh nextcloud root@<server-ip> example.com
```

Access at `https://example.com/nextcloud`

Admin credentials are set during the first-run setup wizard.

Data is persisted in the `nextcloud-data` Podman volume at:
`/root/.local/share/containers/storage/volumes/nextcloud-data/_data/`

## Jellyfin

Jellyfin — a self-hosted media server for streaming movies, TV, and music.

```bash
./services/deploy.sh jellyfin root@<server-ip> example.com
```

Access at `https://example.com/jellyfin`

The setup wizard runs on first access to configure your media libraries and admin account.

Data is persisted in two Podman volumes:

- `jellyfin-config` at `/root/.local/share/containers/storage/volumes/jellyfin-config/_data/`
- `jellyfin-cache` at `/root/.local/share/containers/storage/volumes/jellyfin-cache/_data/`

### TV apps

TV apps (Samsung, LG, Android TV, etc.) do not support a base URL path like `/jellyfin`. They must connect via the subdomain:

```
https://jellyfin.example.com
```

This requires a `jellyfin.example.com` DNS record pointing to the server. The subdomain route is already configured in the container labels.

### Samsung TV

The official Jellyfin app is not available on the Samsung app store. Use [Samsung-Jellyfin-Installer](https://github.com/Jellyfin2Samsung/Samsung-Jellyfin-Installer) to sideload it.
