# tmux utilities

# open nvim in a split pane to the left
nw() {
  tmux split-window -hb -c "#{pane_current_path}" nvim "$@"
}
