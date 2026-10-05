# fzf utilities

# key bindings (ctrl-r, ctrl-t, alt-c) and ** completion
if [[ $- == *i* ]]; then
  _fzf_shell="${HOMEBREW_PREFIX:-/opt/homebrew}/opt/fzf/shell"
  [[ -r "$_fzf_shell/completion.zsh" ]] && source "$_fzf_shell/completion.zsh"
  [[ -r "$_fzf_shell/key-bindings.zsh" ]] && source "$_fzf_shell/key-bindings.zsh"
  unset _fzf_shell
fi

# cd into a subdirectory (recursive, uses fd)
fcd() {
  local dir
  dir=$(fd --type d | fzf +m --preview "ls {}") && cd "$dir"
}

# cd into an immediate subdirectory (fast, no recursion)
fls() {
  local dir
  dir=$(ls -d */ | fzf +m --preview "ls {}") && cd "$dir"
}

# open a file in $EDITOR
fe() {
  local file
  file=$(fd --type f | fzf --preview "bat --color=always {}") && ${EDITOR:-vim} "$file"
}

# checkout a git branch (deduped: local wins over remote)
fbr() {
  local branch
  branch=$(git branch --all --sort=-committerdate | grep -v HEAD | sed "s/.* //" | sed "s#remotes/origin/##" | awk "!seen[\$0]++" | fzf +m --preview "git log --oneline -20 {}") &&
    git checkout "$branch"
}

# cd into a project
frepo() {
  local dir
  dir=$(ls -d ~/Projects/*/ | fzf +m --preview "ls {}") && cd "$dir"
}

# npm scripts picker
fnpm() {
  local script
  script=$(jq -r ".scripts | keys[]" package.json | fzf --preview "jq -r \".scripts.\\\"{}\\\"\" package.json")
  [ -n "$script" ] && npm run "$script"
}
