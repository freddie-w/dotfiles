# git aliases and helpers

alias ga='git add'
alias gaa='git add --all'
alias gcb='git checkout -b'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias ggpush='git push origin "$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD)"'
alias gl='git pull'
alias grb='git rebase'
alias grh='git reset'
alias gst='git status'
alias gsta='git stash push'
alias gstp='git stash pop'

# count commits on the current branch since <base-branch>
count_branch_commits() {
  if [ -z "$1" ]; then
    echo "Usage: count_branch_commits <base-branch>"
    return 1
  fi
  git rev-list --count "$1"..HEAD
}
