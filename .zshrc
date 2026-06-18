if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/opt/homebrew/bin:$PATH"
export PATH=$HOME/.cargo/bin:$PATH
export CONFIG_DIR="$HOME/.config/lazygit"

# Path to oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

export EDITOR="nvim"
export VISUAL="nvim"

plugins=(
   git
   zsh-autosuggestions 
   zsh-syntax-highlighting
)

ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

source $ZSH/oh-my-zsh.sh

# Aliases
alias lg="lazygit"
# Only alias cd to zoxide in interactive shells (avoids errors in Claude Code etc.)
[[ $- == *i* ]] && alias cd="z"
# Open nvim with a per-window socket so claude-inspect can connect to it
alias n='nvim --listen /tmp/nvim-$(tmux display-message -p "#{window_id}" 2>/dev/null || echo $$).sock'

# Functions
count_branch_commits() {
    if [ -z "$1" ]; then
        echo "Usage: count_branch_commits <base-branch>"
        return 1
    fi
    git rev-list --count "$1"..HEAD
}

# Load custom function groups
if [ -f ~/.zshrc.d ]; then
  for file in ~/.zshrc.d/*.zsh; do
    [[ -r "$file" ]] && source "$file"
  done
fi

eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
