vim.pack.add {
  'https://github.com/stevearc/conform.nvim',
}

require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'eslint_d', 'prettierd' },
    typescript = { 'eslint_d', 'prettierd' },
    javascriptreact = { 'eslint_d', 'prettierd' },
    typescriptreact = { 'eslint_d', 'prettierd' },
    css = { 'prettierd' },
    html = { 'prettierd' },
    json = { 'prettierd' },
    jsonc = { 'prettierd' },
  },
}
