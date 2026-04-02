vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig',
}

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

vim.lsp.enable { 'lua_ls', 'vtsls' }

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
