-- Ctrl+h/j/k/l moves between nvim windows, then on into tmux panes at the edges.
-- The matching tmux bindings are in tmux.conf.
vim.g.tmux_navigator_no_mappings = 1

vim.pack.add {
  'https://github.com/christoomey/vim-tmux-navigator',
}

vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<cr>', { desc = 'Move focus to the left window or tmux pane' })
vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<cr>', { desc = 'Move focus to the lower window or tmux pane' })
vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<cr>', { desc = 'Move focus to the upper window or tmux pane' })
vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<cr>', { desc = 'Move focus to the right window or tmux pane' })
