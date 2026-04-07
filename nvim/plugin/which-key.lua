vim.pack.add {
  'https://github.com/folke/which-key.nvim',
}

require('which-key').setup {
  event = 'VimEnter',
  delay = 100,
  icons = { mappings = vim.g.have_nerd_font },
}
