# dotfiles

Personal macOS dotfiles with interactive setup

## Quick Start

```bash
# Clone
git clone https://github.com/kangju2000/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Interactive setup (default - choose what to install)
./bootstrap.sh

# Or install everything
./bootstrap.sh --all
```

## Usage

```bash
# Interactive mode (default)
./bootstrap.sh
# Prompts: Install brew? Install zsh? Install cursor? etc.

# Install all modules without prompts
./bootstrap.sh --all

# Update all packages and plugins
./bootstrap.sh --update

# Combine options
./bootstrap.sh --all --update
```

## Post-Install

```bash
# Setup secrets
vi secrets/.secrets

# Create symlinks for dotfiles
stow zsh git
```
