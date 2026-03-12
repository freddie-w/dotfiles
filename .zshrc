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

source $ZSH/oh-my-zsh.sh

# Aliases
alias lg="lazygit"
alias cd="z"
alias n='nvim'

# Functions
count_branch_commits() {
    if [ -z "$1" ]; then
        echo "Usage: count_branch_commits <base-branch>"
        return 1
    fi
    git rev-list --count "$1"..HEAD
}


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(zoxide init zsh)"
