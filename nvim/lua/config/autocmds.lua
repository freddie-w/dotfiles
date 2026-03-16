vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('no_auto_comment', {}),
  callback = function() vim.opt_local.formatoptions:remove { 'c', 'r', 'o' } end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('active_cursorline', { clear = true }),
  callback = function() vim.opt_local.cursorline = true end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
  group = 'active_cursorline',
  callback = function() vim.opt_local.cursorline = false end,
})

-- Auto-continue markdown checklists
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    -- Use an insert mode Enter mapping
    vim.keymap.set('i', '<CR>', function()
      local line = vim.api.nvim_get_current_line()
      -- Match lines that start with "- [ ]" or "- [x]"
      local prefix = line:match '^([%s]*%- %[.%])%s*'
      if prefix then
        -- Insert a new line with the same prefix
        return '\n' .. prefix .. ' '
      else
        -- Default Enter behavior
        return '\n'
      end
    end, { expr = true, buffer = true })
  end,
})
