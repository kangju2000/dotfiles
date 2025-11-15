# dotfiles

```bash
# Install
git clone https://github.com/kangju2000/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh

# Setup secrets
vi secrets/.secrets

# Stow dotfiles
stow zsh git

# Update everything
./bootstrap.sh --update
```
