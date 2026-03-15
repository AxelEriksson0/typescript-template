# Services

Services are deployed post-boot using scripts in the `services/` directory. The base image is not modified.

## Deploy a service

```bash
./services/deploy.sh <service> <user@host> [install-args...]
```

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
