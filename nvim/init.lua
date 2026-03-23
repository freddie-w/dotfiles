require 'config.globals'
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.diagnostics'
require 'config.statusline'
require 'config.search'

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
    end
  end,
})

vim.pack.add {
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}

vim.cmd.colorscheme 'tokyonight'

-- TODO
-- /027   lspconfig.lua - setup but missing some config?
-- /035   treesitter.lua - setup but missing some config?
-- inline diagnostics dont seem to work
-- add nvim-lint?
