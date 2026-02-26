return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local filetypes = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
    require('nvim-treesitter.configs').setup {
      ensure_installed = filetypes,
      sync_install = false,
      ignore_install = {},
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      playground = { enable = true },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { 'BufWrite', 'CursorHold' },
      },
      modules = {},
    }
  end,
}
