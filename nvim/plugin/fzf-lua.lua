vim.pack.add {
  'https://github.com/ibhagwan/fzf-lua',
}

require('fzf-lua').setup {
  'default-title',
  fzf_opts = {
    ['--layout'] = 'default',
  },
  winopts = {
    preview = { default = 'bat' },
  },
  keymap = {
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
    },
  },
}

local fzf = require 'fzf-lua'
vim.keymap.set('n', '<leader>sh', fzf.helptags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', fzf.builtin, { desc = '[S]earch [S]elect pickers' })
vim.keymap.set({ 'n', 'v' }, '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', fzf.diagnostics_document, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', fzf.oldfiles, { desc = '[S]earch Recent Files' })
vim.keymap.set('n', '<leader>sc', function() fzf.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch Neovim [C]onfig' })
vim.keymap.set('n', '<leader><leader>', fzf.buffers, { desc = 'Search open buffers' })
vim.keymap.set('n', '<leader>/', fzf.lgrep_curbuf, { desc = '[/] Grep in current buffer' })
vim.keymap.set('n', '<leader>gs', fzf.git_status, { desc = '[G]it [S]tatus' })
