# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Auto NVM - automatically use correct Node version per directory
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Claude CLI
alias claude="$HOME/.claude/local/claude"

# Custom Functions
# Update main/master branch with fast-forward only
git_up_main() {
  # Safety checks
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "⚠️ git repo가 아닙니다."; return 1; }
  git remote get-url origin >/dev/null 2>&1 || { echo "⚠️ origin remote가 없습니다."; return 1; }

  local b
  b=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
  if [ -n "$b" ]; then
    git fetch origin "$b":"$b" && echo "✅ $b 업데이트 완료 (FF-only)"
  else
    echo "⚠️ 기본 브랜치를 찾을 수 없습니다."
  fi
}

alias gu=git_up_main

# Spaceship prompt
source /opt/homebrew/opt/spaceship/spaceship.zsh

# Load secrets (gitignored)
[ -f ~/dotfiles/secrets/.secrets ] && source ~/dotfiles/secrets/.secrets

# Load company-specific configurations (gitignored)
[ -f ~/.company-env ] && source ~/.company-env

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
