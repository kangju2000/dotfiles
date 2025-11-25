#!/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Parse command line arguments
UPDATE_MODE=false
INTERACTIVE=true  # Default to interactive mode

while [[ $# -gt 0 ]]; do
  case $1 in
    --update)
      UPDATE_MODE=true
      echo "🔄 Update mode enabled"
      shift
      ;;
    --all|-a)
      INTERACTIVE=false
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--update] [--all|-a]"
      exit 1
      ;;
  esac
done

echo "🚀 Starting dotfiles setup..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "❌ This script is designed for macOS only."
  exit 1
fi

# Define available setup modules
AVAILABLE_MODULES=("brew" "secrets" "zsh" "karabiner" "cursor" "claude" "zed" "macos")
SELECTED_MODULES=()

if [[ "$INTERACTIVE" == true ]]; then
  echo ""
  echo "Select modules to install (press enter to toggle, 'a' for all, 'd' for done):"
  echo ""

  for module in "${AVAILABLE_MODULES[@]}"; do
    read -q "REPLY?Install $module? (y/n): "
    echo ""
    if [[ "$REPLY" == "y" ]]; then
      SELECTED_MODULES+=("$module")
    fi
  done

  SETUP_ORDER=("${SELECTED_MODULES[@]}")
else
  # Default: install everything
  SETUP_ORDER=("${AVAILABLE_MODULES[@]}")
fi

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
echo "💡 Tips:"
echo "  - Run './bootstrap.sh --update' to update all packages and plugins"
echo "  - Run './bootstrap.sh --all' to install all modules without prompts"
