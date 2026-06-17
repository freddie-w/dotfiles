vim.pack.add {
  { src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range '*' },
}

require('blink.cmp').setup {
  keymap = {
    preset = 'default',
    ['<CR>'] = {
      'accept',
      function(cmp)
        local npairs = require('nvim-autopairs')
        local result = npairs.autopairs_cr()
        vim.api.nvim_feedkeys(result, 'n', false)
      end,
    },
  },
  appearance = {
    nerd_font_variant = 'mono',
  },
  completion = {
    documentation = { auto_show = false },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}
