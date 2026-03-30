Debug self-hosted infrastructure settings by SSHing into the server.

## Step 1 — read connection details from .env

Before doing anything, read `packages/server-infrastructure/.env` to get:

- `SERVER_IP` — the server's IP address
- `SERVER_USER` — the SSH username

Use these to construct the SSH command: `ssh $SERVER_USER@$SERVER_IP`

## Services running on the server

- **Nextcloud** — file sync/storage
- **Joplin** — note syncing server

Service config files live in `packages/self-hosted-infrastructure/services/`.

## Debugging steps

1. SSH into the server using credentials from `.env`
2. Check running containers: `podman ps`
3. Check logs for a specific service: `podman logs <container_name>`
4. Inspect container config: `podman inspect <container_name>`
5. Check systemd container units: `systemctl list-units --type=service | grep container`
6. View service logs via journalctl: `journalctl -u <service_name> -f`

## Common issues

- If a container is not running, check `podman ps -a` to see stopped containers and their exit codes.
- Container configs (`.container` files) live in `packages/self-hosted-infrastructure/services/`.
- After changing a `.container` file on the server, reload with: `systemctl daemon-reload && systemctl restart <service>`

When the user asks to debug server settings, first read `.env`, then SSH in and run the relevant diagnostic commands using the Bash tool, then report findings.
