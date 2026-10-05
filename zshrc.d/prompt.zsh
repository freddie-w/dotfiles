# Prompt: "➜ dir git:(branch)", green arrow or red after a failed command.
# Uses vcs_info, which reads the branch without running `git status`, so it
# stays fast in big repos (no dirty marker).

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%%B%F{blue}git:(%F{red}%b%F{blue})%f%%b '
zstyle ':vcs_info:git:*' actionformats '%%B%F{blue}git:(%F{red}%b|%a%F{blue})%f%%b '

# Vi mode indicator (pairs with the cursor shape in options.zsh): the arrow
# turns light purple in normal mode. The insert arrow is built in precmd,
# while $? still holds the last command's exit status.
_prompt_insert() {
  if (( $? )); then _prompt_insert_symbol='%F{red}➜'; else _prompt_insert_symbol='%F{green}➜'; fi
  _prompt_symbol=$_prompt_insert_symbol
}
_prompt_vi_mode() {
  if [[ $KEYMAP == vicmd ]]; then _prompt_symbol='%F{141}➜'; else _prompt_symbol=$_prompt_insert_symbol; fi
  zle reset-prompt
}
# Back to the insert colour when a line is run, so scrollback stays green/red
_prompt_vi_finish() {
  _prompt_symbol=$_prompt_insert_symbol
  zle reset-prompt
}
autoload -Uz add-zle-hook-widget
add-zle-hook-widget keymap-select _prompt_vi_mode
add-zle-hook-widget line-finish _prompt_vi_finish

precmd_functions=(_prompt_insert $precmd_functions vcs_info)

setopt prompt_subst
PROMPT='%B${_prompt_symbol}%f%b %F{cyan}%c%f ${vcs_info_msg_0_}'
