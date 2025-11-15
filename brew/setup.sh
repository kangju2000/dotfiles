#!/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
UPDATE_MODE=${1:-false}

echo "📦 Setting up Homebrew..."

# Install Homebrew if not already installed
if ! command -v brew >/dev/null 2>&1; then
  echo "📦 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for Apple Silicon
  if [[ $(uname -m) == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "✅ Homebrew already installed"
fi

# Update mode: update packages and regenerate Brewfile
if [ "$UPDATE_MODE" = true ]; then
  echo "🔄 Updating Homebrew packages..."
  brew update && brew upgrade

  echo "🔄 Regenerating Brewfile..."
  cd "$DOTFILES_DIR" && brew bundle dump --force
else
  # Install packages from Brewfile
  if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    echo "📦 Installing packages from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
  else
    echo "⚠️ Brewfile not found, skipping package installation"
  fi
fi

# Install GNU Stow for symlink management
if ! command -v stow >/dev/null 2>&1; then
  echo "📦 Installing GNU Stow..."
  brew install stow
else
  echo "✅ GNU Stow already installed"
fi
