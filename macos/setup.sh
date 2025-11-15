#!/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "🍎 Setting up macOS..."

# Apply macOS settings
if [ -f "$DOTFILES_DIR/macos/.macos" ]; then
  "$DOTFILES_DIR/macos/.macos"
else
  echo "⚠️ .macos script not found, skipping"
fi
