#!/usr/bin/env bash
# Installs Jellyfin as a systemd user service via Podman Quadlet.
# Usage: ./install.sh [host]
# Example: ./install.sh 77.42.66.83
#          ./install.sh jellyfin.example.com
set -e -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QUADLET_DIR="$HOME/.config/containers/systemd"
HOST=${1:-"localhost"}

mkdir -p "$QUADLET_DIR"

sed "s|JELLYFIN_HOST|$HOST|g" \
  "$SCRIPT_DIR/jellyfin.container" > "$QUADLET_DIR/jellyfin.container"

systemctl --user daemon-reload
systemctl --user restart jellyfin.service

# Wait for Jellyfin to create its config directory (up to 60s)
echo "Waiting for Jellyfin to initialize..."
for i in $(seq 1 30); do
  if podman exec systemd-jellyfin test -d /config/config 2>/dev/null; then
    break
  fi
  sleep 2
done

# Configure BaseUrl so assets load correctly when served under /jellyfin
CONFIG_FILE="/config/config/network.xml"
podman exec systemd-jellyfin bash -c "
  if [ -f '$CONFIG_FILE' ]; then
    if grep -q '<BaseUrl>' '$CONFIG_FILE'; then
      sed -i 's|<BaseUrl>.*</BaseUrl>|<BaseUrl>/jellyfin</BaseUrl>|' '$CONFIG_FILE'
    else
      sed -i 's|</NetworkConfiguration>|  <BaseUrl>/jellyfin</BaseUrl>\n</NetworkConfiguration>|' '$CONFIG_FILE'
    fi
  else
    mkdir -p /config/config
    cat > '$CONFIG_FILE' << 'EOF'
<?xml version=\"1.0\" encoding=\"utf-8\"?>
<NetworkConfiguration xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">
  <BaseUrl>/jellyfin</BaseUrl>
</NetworkConfiguration>
EOF
  fi
"

systemctl --user restart jellyfin.service

echo "Jellyfin deployed. Access at https://$HOST/jellyfin"
