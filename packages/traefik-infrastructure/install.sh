#!/usr/bin/env bash
# Installs Traefik as a systemd user service via Podman Quadlet.
# Usage: ./install.sh <domain> <email>
# Example: ./install.sh example.com admin@example.com
set -e -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QUADLET_DIR="$HOME/.config/containers/systemd"
DOMAIN=${1:-"localhost"}
EMAIL=${2:-"admin@localhost"}

mkdir -p "$QUADLET_DIR"

sed "s|TRAEFIK_EMAIL|$EMAIL|g" \
  "$SCRIPT_DIR/traefik.yml" > "$QUADLET_DIR/traefik.yml"

cp "$SCRIPT_DIR/traefik.container" "$QUADLET_DIR/traefik.container"
cp "$SCRIPT_DIR/traefik.network"   "$QUADLET_DIR/traefik.network"

touch "$QUADLET_DIR/acme.json"
chmod 600 "$QUADLET_DIR/acme.json"

systemctl --user daemon-reload
systemctl --user restart traefik.service

echo "Traefik deployed. Services at https://$DOMAIN/<service>"
