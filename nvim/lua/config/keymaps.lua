-- General
vim.keymap.set('i', 'jj', '<Esc>')
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
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Toggle oil
vim.keymap.set('n', '<leader>e', function() require('oil').toggle_float() end, { desc = 'Open Oil' })

-- Markdown
vim.keymap.set('n', '<leader>nn', function()
  local notes_dir = '~/notes/'
  local today = os.date '%Y-%m-%d'
  if type(today) ~= 'string' then today = '' end

  local name = vim.fn.input('Note name: ', today)
  if name == '' then return end

  -- Replace spaces with dashes for filenames
  local filename = notes_dir .. name:gsub('%s+', '-') .. '.md'

  -- Frontmatter + template
  local template = {
    '---',
    'title: ' .. name,
    'tags: []',
    'created: ' .. os.date '%Y-%m-%d',
    '---',
    '',
    '# ' .. name,
    '',
  }

  -- Open the new file
  vim.cmd('edit ' .. filename)
end, { desc = "Create new note with today's date" })
