#!/usr/bin/env bash
# Upload media files to the Jellyfin server.
# Usage: ./upload-media.sh <source-path> <user@host> <movies|tv>
# Example: ./upload-media.sh ~/Movies root@192.168.1.10 movies

set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <source-path> <user@host> <movies|tv>" >&2
  exit 1
fi

SOURCE="$1"
TARGET_HOST="$2"
MEDIA_TYPE="$3"

if [[ "$MEDIA_TYPE" != "movies" && "$MEDIA_TYPE" != "tv" ]]; then
  echo "Error: type must be 'movies' or 'tv'" >&2
  exit 1
fi

REMOTE_DIR="/srv/jellyfin/$MEDIA_TYPE"

# Ensure the remote directory exists
ssh "$TARGET_HOST" "mkdir -p $REMOTE_DIR"

# Sync files — preserve times, show progress, skip already-transferred files
rsync -avh --progress --ignore-existing "$SOURCE" "$TARGET_HOST:$REMOTE_DIR/"
