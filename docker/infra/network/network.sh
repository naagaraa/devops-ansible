#!/usr/bin/env bash
set -euo pipefail

NETWORK_NAME="devops"
SUBNET="172.30.0.0/24"

if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    echo "✓ Network '$NETWORK_NAME' already exists."
else
    echo "Creating Docker network '$NETWORK_NAME'..."
    docker network create \
        --driver bridge \
        --subnet "$SUBNET" \
        "$NETWORK_NAME"

    echo "✓ Network created."
fi
