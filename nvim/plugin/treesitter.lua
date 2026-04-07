vim.pack.add {
  'https://github.com/nvim-treesitter/nvim-treesitter',
}

local parsers = {
  'lua',
  'javascript',
  'html',
  'tsx',
  'css',
  'json',
  'dockerfile',
}

require('nvim-treesitter').install(parsers)

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local filetype = vim.bo[args.buf].filetype

    -- check if a parser exists before starting
    if vim.treesitter.language.get_lang(filetype) then pcall(vim.treesitter.start, args.buf) end
  end,
})
