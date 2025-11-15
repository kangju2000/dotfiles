#!/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "⌨️ Setting up Karabiner-Elements..."

# Check if Karabiner-Elements is installed
if ! command -v karabiner_cli &> /dev/null; then
  echo "❌ Karabiner-Elements is not installed"
  echo "📦 Installing Karabiner-Elements via Homebrew..."
  brew install --cask karabiner-elements
fi

# Create config directory if it doesn't exist
mkdir -p ~/.config/karabiner

# Backup existing config if it exists
if [ -f ~/.config/karabiner/karabiner.json ]; then
  echo "📦 Backing up existing Karabiner config..."
  cp ~/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json.backup.$(date +%Y%m%d_%H%M%S)
fi

# Symlink the config file
echo "🔗 Creating symlink for Karabiner config..."
ln -sf "$DOTFILES_DIR/karabiner/karabiner.json" ~/.config/karabiner/karabiner.json

echo "✅ Karabiner-Elements setup complete!"
echo "ℹ️  You may need to grant necessary permissions in System Preferences > Privacy & Security"
