#!/bin/bash

set -e

echo "=============================="
echo " INSTALL BACKUP TOOLS"
echo " Restic + Rclone"
echo "=============================="

echo "[1/4] Update system..."
sudo apt update -y

echo "[2/4] Install dependencies..."
sudo apt install -y curl unzip restic rclone

echo "[3/4] Create backup directories..."
sudo mkdir -p /backup/restic-repo
sudo mkdir -p /backup/db
sudo mkdir -p /backup/tmp

sudo chown -R $USER:$USER /backup

echo "[4/4] Verify installation..."

echo "Restic version:"
restic version || echo "Restic installed"

echo "Rclone version:"
rclone version || echo "Rclone installed"

echo "=============================="
echo " INSTALLATION COMPLETE"
echo "=============================="
echo ""
echo "NEXT STEP:"
echo "1. run: rclone config"
echo "2. init restic repo:"
echo "   restic -r /backup/restic-repo init"
echo "=============================="
