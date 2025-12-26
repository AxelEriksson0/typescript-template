#!/bin/bash
set -e -o pipefail

echo "waiting for cloud-init to finish..."
if ! cloud-init status --wait; then
    echo "Note: cloud-init failed or was already completed."
fi

echo "installing packages..."
apt-get update
apt-get install --yes --no-install-recommends wget fail2ban

# My setup...

echo "cleanup..."
cloud-init clean --machine-id --seed --logs