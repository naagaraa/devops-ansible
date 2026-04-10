#!/bin/bash
# Script to retrieve SSH keys for a user
# Usage: ./get-ssh-key.sh <username>

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEYS_DIR="$SCRIPT_DIR/../ssh-assets"
USER="$1"

if [ -z "$USER" ]; then
    echo "Usage: $0 <username>"
    echo "Available users:"
    ls -1 "$KEYS_DIR/users/" 2>/dev/null || echo "  No users found"
    exit 1
fi

USER_DIR="$KEYS_DIR/users/$USER"

if [ ! -d "$USER_DIR" ]; then
    echo "Error: User $USER not found"
    exit 1
fi

echo "=== SSH Key for $USER ==="
echo ""
echo "Private Key (save to ~/.ssh/id_ed25519):"
echo "---"
cat "$USER_DIR/${USER}_key"
echo "---"
echo ""
echo "Certificate (save to ~/.ssh/id_ed25519-cert.pub):"
echo "---"
cat "$USER_DIR/${USER}_key-cert.pub"
echo "---"
echo ""
echo "Public Key:"
echo "---"
cat "$USER_DIR/${USER}_key.pub"
echo "---"
echo ""
echo "Quick setup:"
echo "  mkdir -p ~/.ssh"
echo "  chmod 700 ~/.ssh"
echo "  cp $USER_DIR/${USER}_key ~/.ssh/id_ed25519"
echo "  cp $USER_DIR/${USER}_key-cert.pub ~/.ssh/id_ed25519-cert.pub"
echo "  chmod 600 ~/.ssh/id_ed25519"
echo "  chmod 644 ~/.ssh/id_ed25519-cert.pub"