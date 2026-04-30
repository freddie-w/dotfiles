vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  desc = 'Check for external file changes',
  group = vim.api.nvim_create_augroup('autoread_on_focus', { clear = true }),
  command = 'checktime',
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- No auto continue comments on new line
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('no_auto_comment', {}),
  callback = function() vim.opt_local.formatoptions:remove { 'c', 'r', 'o' } end,
})

-- Show cursorline only in active window enable
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('active_cursorline', { clear = true }),
  callback = function() vim.opt_local.cursorline = true end,
})

-- Show cursorline only in active window disable
vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
  group = 'active_cursorline',
  callback = function() vim.opt_local.cursorline = false end,
})
