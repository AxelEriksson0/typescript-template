#!/bin/bash
set -e -o pipefail

echo "waiting for cloud-init to finish..."
if ! cloud-init status --wait; then
    echo "Note: cloud-init failed or was already completed."
fi

echo "installing packages..."