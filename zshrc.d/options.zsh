# Shell options, history and key bindings

# History (macOS defaults keep only 1000 lines)
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history       # record timestamps
setopt hist_expire_dups_first # drop duplicates first when trimming
setopt hist_ignore_dups       # don't record a command twice in a row
setopt hist_ignore_space      # don't record commands starting with a space
setopt hist_verify            # show !! expansions before running them
setopt share_history          # share history between open shells

# Directories
setopt auto_cd                # type a directory name to cd into it
setopt auto_pushd             # cd pushes onto the dir stack (cd -<Tab>)
setopt pushd_ignore_dups
setopt pushd_minus

setopt interactive_comments
setopt long_list_jobs

# Vi mode (enabled in .zshrc) -------------------------------------------------

# Switch to normal mode as soon as Esc is pressed (default waits 0.4s)
KEYTIMEOUT=1

# Cursor shape shows the mode, like nvim: bar in insert, block in normal
_vi_cursor() {
  if [[ $KEYMAP == vicmd ]]; then printf '\e[2 q'; else printf '\e[6 q'; fi
}
autoload -Uz add-zle-hook-widget
add-zle-hook-widget keymap-select _vi_cursor
add-zle-hook-widget line-init _vi_cursor

# Up/down search history for commands starting with what's typed (k/j in normal)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
for km in viins vicmd; do
  bindkey -M $km '^[[A' up-line-or-beginning-search
  bindkey -M $km '^[OA' up-line-or-beginning-search
  bindkey -M $km '^[[B' down-line-or-beginning-search
  bindkey -M $km '^[OB' down-line-or-beginning-search
done
unset km
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search

# Ctrl-R redoes in normal mode, like nvim (fzf history stays on Ctrl-R in insert)
bindkey -M vicmd '^R' redo

# Emacs-style keys that still work in insert mode
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^W' backward-kill-word
# Backspace past the point where insert mode started (vi default stops there)
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

# Home/End, Delete, Ctrl/Option + arrows to move by word
bindkey -M viins '^[[H' beginning-of-line
bindkey -M viins '^[OH' beginning-of-line
bindkey -M viins '^[[F' end-of-line
bindkey -M viins '^[OF' end-of-line
bindkey -M viins '^[[3~' delete-char
bindkey -M viins '^[[1;5C' forward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M viins '^[[1;3C' forward-word
bindkey -M viins '^[[1;3D' backward-word

# Edit the current command in $EDITOR: v in normal mode, Ctrl-X Ctrl-E in insert
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line
bindkey -M viins '^X^E' edit-command-line
