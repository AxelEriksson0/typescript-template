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

# Behind Cloudflare, Collabora's WOPI callback to `https://$HOST` goes out to
# Cloudflare and re-enters from a different edge IP on each request. AIO's
# default wopi_allowlist pins only the two IPs it resolved at setup time, so
# most callbacks get denied as "Unauthorized WOPI host". Allowlist Cloudflare's
# full published ranges plus internal networks. Skipped silently if Nextcloud
# hasn't been created yet (first install happens after the setup wizard).
CF_V4="173.245.48.0/20,103.21.244.0/22,103.22.200.0/22,103.31.4.0/22,141.101.64.0/18,108.162.192.0/18,190.93.240.0/20,188.114.96.0/20,197.234.240.0/22,198.41.128.0/17,162.158.0.0/15,104.16.0.0/13,104.24.0.0/14,172.64.0.0/13,131.0.72.0/22"
CF_V6="2400:cb00::/32,2606:4700::/32,2803:f800::/32,2405:b500::/32,2405:8100::/32,2a06:98c0::/29,2c0f:f248::/32"
INTERNAL="127.0.0.0/8,192.168.0.0/16,172.16.0.0/12,10.0.0.0/8,100.64.0.0/10,fd00::/8,::1/128"
if podman exec nextcloud-aio-nextcloud true 2>/dev/null; then
  podman exec -u 33 nextcloud-aio-nextcloud \
    php /var/www/html/occ config:app:set richdocuments wopi_allowlist \
    --value="${CF_V4},${CF_V6},${INTERNAL}" >/dev/null
fi

echo "Nextcloud AIO deployed."
echo "  Management UI: https://$HOST/aio-admin/"
echo "  Main Nextcloud: https://$HOST/ (after setup)"
