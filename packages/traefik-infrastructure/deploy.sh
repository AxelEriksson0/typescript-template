#!/usr/bin/env bash
# Deploys Traefik to a remote server.
# Usage: ./deploy.sh <user@host> <domain> <email>
# Example: ./deploy.sh root@1.2.3.4 example.com admin@example.com
set -e -o pipefail

SERVER=${1:?Usage: deploy.sh <user@host> <domain> <email>}
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Deploying traefik to $SERVER..."
ssh "$SERVER" "mkdir -p ~/traefik"
scp -r "$SCRIPT_DIR/." "$SERVER:~/traefik/"
ssh "$SERVER" "bash ~/traefik/install.sh ${@:2}"
