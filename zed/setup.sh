#!/bin/bash

# Zed settings
ZED_USER_DIR="$HOME/.config/zed"
mkdir -p "$ZED_USER_DIR"

ln -sf "$PWD/zed/settings.json" "$ZED_USER_DIR/settings.json"
ln -sf "$PWD/zed/keymap.json" "$ZED_USER_DIR/keymap.json"

echo "✓ Zed settings linked"
