vim.pack.add {
  { src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range '*' },
}

require('blink.cmp').setup {
  keymap = { preset = 'default', ['<CR>'] = { 'select_and_accept', 'fallback' } },
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
