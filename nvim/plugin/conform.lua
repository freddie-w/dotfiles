vim.pack.add {
  'https://github.com/stevearc/conform.nvim',
}

require('conform').setup {
  format_on_save = {
    timeout_ms = 5000,
    lsp_format = 'fallback',
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescriptreact = { 'prettier' },
    css = { 'prettier' },
    html = { 'prettier' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    python = { 'ruff_organize_imports', 'ruff_format' },
  },
}
