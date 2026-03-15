#!/usr/bin/env bash
# Installs NextCloud as a systemd user service via Podman Quadlet.
# Usage: ./install.sh [host]
# Example: ./install.sh 77.42.66.83
#          ./install.sh nextcloud.example.com
set -e -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QUADLET_DIR="$HOME/.config/containers/systemd"
HOST=${1:-"localhost"}

mkdir -p "$QUADLET_DIR"

sed "s|NEXTCLOUD_HOST|$HOST|g" \
  "$SCRIPT_DIR/nextcloud.container" > "$QUADLET_DIR/nextcloud.container"

systemctl --user daemon-reload
systemctl --user restart nextcloud.service

echo "NextCloud deployed. Access at https://$HOST/nextcloud"
