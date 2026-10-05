# Tab completion

autoload -Uz compinit
# Work Macs: Workbrew owns /opt/homebrew, so compinit treats its completion
# folders as insecure and refuses to load them. -u skips that ownership check.
# Personal Macs own /opt/homebrew themselves, so keep the check there.
if [[ -d /opt/workbrew ]]; then
  compinit -u
else
  compinit
fi

setopt auto_menu       # Tab twice to open the menu
setopt complete_in_word
setopt always_to_end

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''
