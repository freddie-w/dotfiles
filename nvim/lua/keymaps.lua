-- General
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('n', '<leader>e', function() require('oil').toggle_float() end, { desc = 'Toggle Oil' })

-- Diagnostics
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump { count = 1 } end, { desc = 'Next diagnostic' })
vim.keymap.set('n', '[d', function() vim.diagnostic.jump { count = -1 } end, { desc = 'Previous diagnostic' })

-- Terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Buffers
vim.keymap.set('n', '<leader>bd', ':bd<CR>', { desc = 'Close current buffer' })
vim.keymap.set('n', ']b', ':bnext<CR>', { desc = 'Go to next buffer' })
vim.keymap.set('n', ']b', ':bprev<CR>', { desc = 'Go to previous buffer' })

-- Windows
vim.keymap.set('n', '<leader>|', '<C-w>v', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>-', '<C-w>s', { desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>wd', '<C-w>c', { desc = 'Close current window' })

-- Motions
vim.keymap.set('n', 'H', '^', { desc = 'Move to start of line' })
vim.keymap.set('n', 'L', '$', { desc = 'Move to end of line' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Incremental selection
vim.keymap.set('x', 'n', function() require('vim.treesitter._select').select_parent(vim.v.count1) end, { desc = 'Expand selection' })
vim.keymap.set('x', 'N', function() require('vim.treesitter._select').select_child(vim.v.count1) end, { desc = 'Shrink selection' })
