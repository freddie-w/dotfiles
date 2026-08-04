# fzf utilities

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
  file=$(fzf --preview "cat -n {}") && ${EDITOR:-vim} "$file"
}

# checkout a git branch
fbr() {
  local branch
  branch=$(git branch --all --sort=-committerdate | grep -v HEAD | fzf +m --preview "git log --oneline -20 {}") &&
    git checkout "$(echo "$branch" | sed "s/.* //" | sed "s#remotes/origin/##")"
}

# npm scripts picker
fnpm() {
  local script
  script=$(jq -r ".scripts | keys[]" package.json | fzf --preview "jq -r \".scripts.\\\"{}\\\"\" package.json")
  [ -n "$script" ] && npm run "$script"
}
