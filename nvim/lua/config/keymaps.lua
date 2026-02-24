-- General
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Buffers
vim.keymap.set('n', '<leader>bd', ':bd<CR>', { desc = 'Close current buffer' })

-- Windows
vim.keymap.set('n', '<leader>|', '<C-w>v', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>-', '<C-w>s', { desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>wd', '<C-w>c', { desc = 'Close current window' })

-- Motions
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-j>', '5j', { desc = 'Move down 5 lines' })
vim.keymap.set('n', '<C-k>', '5k', { desc = 'Move up 5 lines' })

-- Plugins
vim.keymap.set('n', '<leader>e', function() require('oil').toggle_float() end, { desc = 'Open Oil' })
