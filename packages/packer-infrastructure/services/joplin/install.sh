#!/usr/bin/env bash
# Installs Joplin Server as a systemd user service via Podman Quadlet.
# Usage: ./install.sh [host]
# Example: ./install.sh 77.42.66.83
#          ./install.sh joplin.example.com
set -e -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QUADLET_DIR="$HOME/.config/containers/systemd"
HOST=${1:-"localhost"}

mkdir -p "$QUADLET_DIR"

sed "s|JOPLIN_HOST|$HOST|g" \
  "$SCRIPT_DIR/joplin.container" > "$QUADLET_DIR/joplin.container"

systemctl --user daemon-reload
systemctl --user restart joplin.service

echo "Joplin Server deployed. Access at https://$HOST/joplin"
