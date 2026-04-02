vim.pack.add {
  'https://github.com/nvim-treesitter/nvim-treesitter',
}

require('nvim-treesitter').install { 'lua', 'javascript', 'html', 'tsx', 'css', 'json', 'dockerfile' }

-- Enable syntax highlighting
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function() vim.treesitter.start() end,
})
