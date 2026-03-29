#!/usr/bin/env bash
# Upload media files to the Jellyfin server.
# Usage: ./upload-media.sh <source-path> <user@host>
# Example: ./upload-media.sh ~/Movies root@192.168.1.10

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <source-path> <user@host>" >&2
  exit 1
fi

SOURCE="$1"
TARGET_HOST="$2"
REMOTE_DIR="/srv/jellyfin-media"

# Ensure the remote directory exists
ssh "$TARGET_HOST" "mkdir -p $REMOTE_DIR"

# Sync files — preserve times, show progress, skip already-transferred files
rsync -avh --progress --ignore-existing "$SOURCE" "$TARGET_HOST:$REMOTE_DIR/"
