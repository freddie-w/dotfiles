vim.pack.add {
  'https://github.com/folke/which-key.nvim',
}

require('which-key').setup {
  delay = 100,
  icons = { mappings = vim.g.have_nerd_font },
}
