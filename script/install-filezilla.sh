#!/usr/bin/env sh
set -eu

APP_NAME="FileZilla"
INSTALL_DIR="/opt/filezilla"
DESKTOP_FILE="$HOME/.local/share/applications/filezilla.desktop"

# ===== INPUT =====
# Bisa pakai:
# FILEZILLA_TAR=/path/filezilla.tar.xz sh install-filezilla.sh
TAR_FILE="${FILEZILLA_TAR:-}"

echo "==> FileZilla TAR Installer"

# ===== VALIDASI =====
if [ -z "$TAR_FILE" ]; then
  echo "❌ ERROR: Path file tar belum ditentukan"
  echo "➡️  Contoh:"
  echo "   FILEZILLA_TAR=~/Downloads/FileZilla_*.tar.xz sh install-filezilla.sh"
  exit 1
fi

if [ ! -f "$TAR_FILE" ]; then
  echo "❌ ERROR: File tidak ditemukan: $TAR_FILE"
  exit 1
fi

# ===== PREP =====
echo "==> Membuat folder install: $INSTALL_DIR"
sudo mkdir -p "$INSTALL_DIR"

TMP_DIR="$(mktemp -d)"

echo "==> Extract FileZilla"
tar -xf "$TAR_FILE" -C "$TMP_DIR"

# detect folder hasil extract
EXTRACTED_DIR="$(find "$TMP_DIR" -maxdepth 1 -type d -name 'FileZilla*' | head -n 1)"

if [ -z "$EXTRACTED_DIR" ]; then
  echo "❌ ERROR: Folder FileZilla tidak ditemukan setelah extract"
  exit 1
fi

echo "==> Menyalin FileZilla ke $INSTALL_DIR"
sudo rm -rf "$INSTALL_DIR"/*
sudo cp -r "$EXTRACTED_DIR"/* "$INSTALL_DIR/"

# permission
sudo chmod +x "$INSTALL_DIR/bin/filezilla"

# ===== ICON =====
ICON_PATH=""
if [ -f "$INSTALL_DIR/share/icons/hicolor/256x256/apps/filezilla.png" ]; then
  ICON_PATH="$INSTALL_DIR/share/icons/hicolor/256x256/apps/filezilla.png"
fi

# ===== DESKTOP ENTRY =====
echo "==> Membuat launcher menu"
mkdir -p "$HOME/.local/share/applications"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=$APP_NAME
Comment=FTP, FTPS and SFTP Client
Exec=$INSTALL_DIR/bin/filezilla
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Network;FileTransfer;
StartupWMClass=filezilla
EOF

chmod +x "$DESKTOP_FILE"

# ===== REFRESH =====
update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true

rm -rf "$TMP_DIR"

echo "✅ FileZilla berhasil di-install!"
echo "➡️  Buka menu Ubuntu → cari: FileZilla"
