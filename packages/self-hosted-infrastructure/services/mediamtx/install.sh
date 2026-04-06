#!/usr/bin/env bash
# Installs MediaMTX as a systemd user service via Podman Quadlet.
# Usage: ./install.sh [host]
# Example: ./install.sh 77.42.66.83
#          ./install.sh example.com
set -e -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QUADLET_DIR="$HOME/.config/containers/systemd"

mkdir -p "$QUADLET_DIR"

cp "$SCRIPT_DIR/mediamtx.container" "$QUADLET_DIR/mediamtx.container"

systemctl --user daemon-reload
systemctl --user restart mediamtx.service

echo "MediaMTX deployed."
echo "  RTMP ingest:  rtmp://localhost:1935/live"
echo "  HLS output:   http://localhost:8888/live/index.m3u8"
echo "  RTSP output:  rtsp://localhost:8554/live"
echo "  WebRTC:       http://localhost:8889/live"
