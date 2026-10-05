if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/opt/homebrew/bin:$PATH"
# Work Macs: Workbrew refuses plain `brew` calls that bypass its wrapper, so
# it must come before /opt/homebrew/bin. No-op on personal Macs.
[[ -d /opt/workbrew/bin ]] && export PATH="/opt/workbrew/bin:$PATH"
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
alias n='nvim'
alias lg="lazygit"
# Only alias cd to zoxide in interactive shells (avoids errors in Claude Code etc.)
[[ $- == *i* ]] && alias cd="z"

# Functions
count_branch_commits() {
    if [ -z "$1" ]; then
        echo "Usage: count_branch_commits <base-branch>"
        return 1
    fi
    git rev-list --count "$1"..HEAD
}

# Load custom function groups
if [ -d ~/.zshrc.d ]; then
  for file in ~/.zshrc.d/*.zsh; do
    [[ -r "$file" ]] && source "$file"
  done
fi

eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
