#!/bin/bash
# Install Flutter SDK into ~/flutter
set -e

FLUTTER_VERSION="3.19.6"
INSTALL_DIR="$HOME/flutter"

echo "Installing Flutter $FLUTTER_VERSION..."

if [ -d "$INSTALL_DIR" ]; then
  echo "Flutter already at $INSTALL_DIR — checking version"
  $INSTALL_DIR/bin/flutter --version
  exit 0
fi

cd /tmp
wget -q "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
  -O flutter.tar.xz
echo "Extracting..."
tar xf flutter.tar.xz -C "$HOME"
rm flutter.tar.xz

echo "Adding to PATH..."
SHELL_RC="$HOME/.zshrc"
[ -f "$HOME/.bashrc" ] && SHELL_RC="$HOME/.bashrc"
grep -q 'flutter/bin' "$SHELL_RC" 2>/dev/null || \
  echo 'export PATH="$HOME/flutter/bin:$PATH"' >> "$SHELL_RC"

export PATH="$HOME/flutter/bin:$PATH"
flutter precache
flutter doctor

echo ""
echo "Flutter installed at $INSTALL_DIR"
echo "Run: source $SHELL_RC"
echo "Then: cd mobile && flutter pub get (in each app)"
