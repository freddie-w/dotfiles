return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  dependencies = {},
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
      ['<CR>'] = { 'select_and_accept', 'fallback' }, -- works in insert and select mode
    },
    completion = {
      documentation = { auto_show = false, auto_show_delay_ms = 250 },
    },
    sources = {
      default = { 'lsp', 'path' },
    },
    fuzzy = { implementation = 'lua' },
    signature = { enabled = true },
  },
}
