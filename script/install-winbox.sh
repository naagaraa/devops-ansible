#!/bin/bash
set -e

# ===== CONFIG =====
APP_NAME="WinBox"
INSTALL_DIR="/opt/winbox"
DESKTOP_FILE="$HOME/.local/share/applications/winbox.desktop"

# ===== INPUT FOLDER =====
SRC_DIR="${1:-./WinBox_Linux}"

BIN="$SRC_DIR/WinBox"
ASSETS="$SRC_DIR/assets"
ICON="$INSTALL_DIR/assets/img/winbox.png"

echo "==> WinBox installer"
echo "==> Source folder: $SRC_DIR"

# ===== VALIDATION =====
if [ ! -f "$BIN" ]; then
  echo "❌ ERROR: WinBox binary tidak ditemukan di $SRC_DIR"
  echo "   Struktur harus seperti ini:"
  echo "   $SRC_DIR/WinBox"
  echo "   $SRC_DIR/assets/img/winbox.png"
  exit 1
fi

# ===== INSTALL =====
echo "==> Membuat folder install: $INSTALL_DIR"
sudo mkdir -p "$INSTALL_DIR"

echo "==> Menyalin WinBox dan assets"
sudo cp "$BIN" "$INSTALL_DIR/"
sudo cp -r "$ASSETS" "$INSTALL_DIR/"

echo "==> Mengatur permission"
sudo chmod +x "$INSTALL_DIR/WinBox"

# ===== DESKTOP ENTRY =====
echo "==> Membuat launcher menu Ubuntu"
mkdir -p "$HOME/.local/share/applications"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=$APP_NAME
Comment=MikroTik Router Management Tool
Exec=env GDK_BACKEND=x11 $INSTALL_DIR/WinBox
Icon=$ICON
Terminal=false
Type=Application
Categories=Network;System;
StartupWMClass=winbox
EOF

chmod +x "$DESKTOP_FILE"

# ===== REFRESH =====
update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true

echo "✅ Instalasi selesai!"
echo "➡️  Buka menu Ubuntu → cari: WinBox"
