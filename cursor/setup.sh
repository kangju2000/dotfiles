#!/bin/bash

# Cursor settings
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
mkdir -p "$CURSOR_USER_DIR"

ln -sf "$PWD/cursor/settings.json" "$CURSOR_USER_DIR/settings.json"
ln -sf "$PWD/cursor/keybindings.json" "$CURSOR_USER_DIR/keybindings.json"

echo "✓ Cursor settings linked"

# Install Cursor extensions
if command -v cursor &> /dev/null; then
  echo "📦 Installing Cursor extensions..."
  while IFS= read -r extension; do
    if [ -n "$extension" ]; then
      cursor --install-extension "$extension" 2>/dev/null
    fi
  done < "$PWD/cursor/extensions.txt"
  echo "✓ Cursor extensions installed"
else
  echo "⚠️  Cursor not found in PATH. Skipping extension installation."
fi
