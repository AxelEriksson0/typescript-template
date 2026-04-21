#!/usr/bin/env bash
# Installs Nextcloud All-in-One as a systemd user service via Podman Quadlet.
# Usage: ./install.sh <host>
# Example: ./install.sh nextcloud.example.com
#
# After deployment:
#   - Management UI: https://<host>/aio-admin/
#   - Main Nextcloud: https://<host>/ (once AIO has started its containers)
set -e -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QUADLET_DIR="$HOME/.config/containers/systemd"
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
HOST=${1:?"Usage: $0 <host>"}

mkdir -p "$QUADLET_DIR" "$SYSTEMD_USER_DIR"

# Deploy the Podman socket proxy (fixes AIO inline seccomp incompatibility with Podman)
install -m 755 "$SCRIPT_DIR/podman-aio-proxy.py" /usr/local/bin/podman-aio-proxy.py
cp "$SCRIPT_DIR/podman-aio-proxy.service" "$SYSTEMD_USER_DIR/podman-aio-proxy.service"
systemctl --user daemon-reload
systemctl --user enable --now podman-aio-proxy.service

# Deploy the Nextcloud AIO container
sed "s|NEXTCLOUD_HOST|$HOST|g" \
  "$SCRIPT_DIR/nextcloud.container" > "$QUADLET_DIR/nextcloud.container"

systemctl --user daemon-reload
systemctl --user restart nextcloud.service

# Wait for the mastercontainer volume to be mounted, then set daily backup time.
# daily_backup_time has no env-var override in AIO, so it must be written into
# configuration.json. Idempotent — only sets defaults if the keys are absent.
for _ in {1..30}; do
  podman exec nextcloud-aio-mastercontainer test -f /mnt/docker-aio-config/data/configuration.json 2>/dev/null && break
  sleep 2
done
podman exec nextcloud-aio-mastercontainer python3 - <<'PY'
import json
p = "/mnt/docker-aio-config/data/configuration.json"
d = json.load(open(p))
d.setdefault("daily_backup_time", "04:00")
d.setdefault("borg_backup_host_location", "/mnt/nextcloud_backup")
json.dump(d, open(p, "w"), indent=4)
PY

echo "Nextcloud AIO deployed."
echo "  Management UI: https://$HOST/aio-admin/"
echo "  Main Nextcloud: https://$HOST/ (after setup)"
