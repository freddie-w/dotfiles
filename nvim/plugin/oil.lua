vim.pack.add {
  'https://github.com/stevearc/oil.nvim',
}

require('oil').setup {
  view_options = {
    show_hidden = true,
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
}
