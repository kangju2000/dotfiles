#!/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Parse command line arguments
UPDATE_MODE=false
if [[ "$1" == "--update" ]]; then
  UPDATE_MODE=true
  echo "🔄 Update mode enabled"
fi

echo "🚀 Starting dotfiles setup..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "❌ This script is designed for macOS only."
  exit 1
fi

# Run setup scripts in specific order
SETUP_ORDER=("brew" "secrets" "zsh" "karabiner" "macos")

for dir in "${SETUP_ORDER[@]}"; do
  setup_script="$DOTFILES_DIR/$dir/setup.sh"
  if [ -f "$setup_script" ]; then
    "$setup_script" $UPDATE_MODE
  fi
done

echo ""
echo "✨ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "1. Edit $DOTFILES_DIR/secrets/.secrets with your actual values"
echo "2. Run 'cd $DOTFILES_DIR && stow zsh git' to create symlinks"
echo "3. Restart your terminal or run 'source ~/.zshrc'"
echo ""
echo "💡 Tip: Run './bootstrap.sh --update' to update all packages and plugins"
