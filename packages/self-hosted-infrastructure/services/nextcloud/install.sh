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

echo "Nextcloud AIO deployed."
echo "  Management UI: https://$HOST/aio-admin/"
echo "  Main Nextcloud: https://$HOST/ (after setup)"
