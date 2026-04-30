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

-- Auto close tags
vim.api.nvim_create_autocmd('InsertCharPre', {
  pattern = { '*.html', '*.jsx', '*.tsx' },
  callback = function()
    if vim.v.char ~= '>' then return end

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()

    -- Text before cursor
    local before = line:sub(1, col)

    -- Match opening tag with optional attributes:
    -- <div
    -- <div class=""
    -- <Component prop={x}
    local tag = before:match '<([%w%-]+)[^<>]*$'

    -- Ignore closing tags or self-closing tags
    if tag and not before:match '</' and not before:match '/%s*$' then
      vim.schedule(function()
        vim.api.nvim_put({ '</' .. tag .. '>' }, 'c', true, true)
        -- place cursor between tags
        vim.api.nvim_win_set_cursor(0, { row, col + 1 })
      end)
    end
  end,
})
