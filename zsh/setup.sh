#!/bin/bash

UPDATE_MODE=${1:-false}

echo "🎨 Setting up Zsh..."

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🎨 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✅ Oh My Zsh already installed"
fi

# Install Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "📦 Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "✅ zsh-autosuggestions already installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "📦 Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "✅ zsh-syntax-highlighting already installed"
fi

# Update mode: update Oh My Zsh and plugins
if [ "$UPDATE_MODE" = true ]; then
  echo "🔄 Updating Oh My Zsh..."
  if [ -d "$HOME/.oh-my-zsh" ]; then
    cd "$HOME/.oh-my-zsh" && git pull
  fi

  echo "🔄 Updating Zsh plugins..."
  if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    cd "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && git pull
  fi
  if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    cd "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" && git pull
  fi
fi

# Link .zshrc
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC_SOURCE="$SCRIPT_DIR/.zshrc"
ZSHRC_TARGET="$HOME/.zshrc"

if [ -L "$ZSHRC_TARGET" ]; then
  echo "✅ .zshrc symlink already exists"
elif [ -f "$ZSHRC_TARGET" ]; then
  echo "⚠️  .zshrc already exists as a regular file. Backing up to .zshrc.backup"
  mv "$ZSHRC_TARGET" "$ZSHRC_TARGET.backup"
  ln -s "$ZSHRC_SOURCE" "$ZSHRC_TARGET"
  echo "✅ .zshrc linked successfully"
else
  ln -s "$ZSHRC_SOURCE" "$ZSHRC_TARGET"
  echo "✅ .zshrc linked successfully"
fi
