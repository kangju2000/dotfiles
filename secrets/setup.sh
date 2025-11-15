#!/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "🔐 Setting up secrets..."

# Create secrets file if it doesn't exist
if [ ! -f "$DOTFILES_DIR/secrets/.secrets" ]; then
  echo "🔐 Creating secrets file..."
  cp "$DOTFILES_DIR/secrets/.secrets.example" "$DOTFILES_DIR/secrets/.secrets"
  echo "⚠️ Please edit $DOTFILES_DIR/secrets/.secrets with your actual values"
else
  echo "✅ Secrets file already exists"
fi
