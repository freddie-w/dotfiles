if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/opt/homebrew/bin:$PATH"
export PATH=$HOME/.cargo/bin:$PATH

# Path to oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

plugins=(
   git
   zsh-autosuggestions 
   zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

alias zshconfig="nvim ~/.zshrc"
alias nvimconfig="nvim ~/.config"
alias sourcezshrc="source ~/.zshrc"
alias lg="lazygit"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/Users/freddiewellfair/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
