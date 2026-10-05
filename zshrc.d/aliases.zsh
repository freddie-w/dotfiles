# General aliases

export CLICOLOR=1
alias l='ls -lah'
alias grep='grep --color=auto'

alias n='nvim'
alias lg='lazygit'

# Only alias cd to zoxide in interactive shells (avoids errors in Claude Code etc.)
[[ $- == *i* ]] && alias cd='z'
