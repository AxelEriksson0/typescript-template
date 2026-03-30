#!/usr/bin/env bash
# Usage: ./services/deploy.sh <service> <user@host>
# Example: ./services/deploy.sh joplin root@1.2.3.4
set -e -o pipefail

SERVICE=${1:?Usage: deploy.sh <service> <user@host>}
SERVER=${2:?Usage: deploy.sh <service> <user@host>}
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ ! -d "$SCRIPT_DIR/$SERVICE" ]]; then
  echo "Error: service '$SERVICE' not found in $SCRIPT_DIR"
  exit 1
fi

echo "Deploying $SERVICE to $SERVER..."
ssh "$SERVER" "mkdir -p ~/services"
scp -r "$SCRIPT_DIR/$SERVICE" "$SERVER:~/services/"
ssh "$SERVER" "bash ~/services/$SERVICE/install.sh ${@:3}"
