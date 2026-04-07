vim.pack.add {
  'https://github.com/windwp/nvim-autopairs',
}

require('nvim-autopairs').setup {
  event = 'InsertEnter',
  map_cr = false,
}
