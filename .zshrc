# Homebrew: sets PATH, FPATH (brew completions) and MANPATH. On work Macs,
# /opt/homebrew/etc/paths lists the Workbrew wrapper first, so `brew` resolves
# to /opt/workbrew/bin/brew, which Workbrew requires. No-op on personal Macs.
eval "$(/opt/homebrew/bin/brew shellenv)"

export EDITOR="nvim"
export VISUAL="nvim"
export CONFIG_DIR="$HOME/.config/lazygit"
[[ -d ~/.cargo/bin ]] && path=(~/.cargo/bin $path)

# Vi mode for the command line (tweaks in zshrc.d/options.zsh)
bindkey -v

# Machine-specific settings and secrets (not tracked)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Config groups: aliases, completion, fzf, git, options, prompt, tmux
for file in ~/.zshrc.d/*.zsh; do
  [[ -r "$file" ]] && source "$file"
done
unset file

# Plugins (from Brewfile). Syntax highlighting must load after every widget
# (fzf, key bindings) is defined so it can wrap them.
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Tool hooks. zoxide's docs say to init it last, after compinit.
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
