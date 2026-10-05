# git aliases and helpers

alias ga='git add'
alias gaa='git add --all'
alias gcb='git checkout -b'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gl='git pull'
alias grb='git rebase'
alias grh='git reset'
alias gst='git status'

# count commits on the current branch since <base-branch>
count_branch_commits() {
  if [ -z "$1" ]; then
    echo "Usage: count_branch_commits <base-branch>"
    return 1
  fi
  git rev-list --count "$1"..HEAD
}
