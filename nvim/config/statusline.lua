local M = {}

function M.git_branch()
  local branch = vim.b.gitsigns_head
  if branch then return '  ' .. branch end
  return ''
end

function M.statusline()
  local mode = vim.fn.mode()
  local mode_str = ''
  if mode == 'n' then
    mode_str = '%#StatusLineNormal# NORMAL %#StatusLine#'
  elseif mode == 'i' then
    mode_str = '%#StatusLineInsert# INSERT %#StatusLine#'
  elseif mode == 'v' or mode == 'V' or mode == '' then
    mode_str = '%#StatusLineVisual# VISUAL %#StatusLine#'
  elseif mode == 'c' then
    mode_str = '%#StatusLineCommand# COMMAND %#StatusLine#'
  elseif mode == 'R' then
    mode_str = '%#StatusLineReplace# REPLACE %#StatusLine#'
  elseif mode == 't' then
    mode_str = '%#StatusLineTerminal# TERMINAL %#StatusLine#'
  else
    mode_str = '%#StatusLine# ' .. mode .. ' %#StatusLine#'
  end

  return table.concat({
    mode_str,
    ' %f', -- full file path
    '%r', -- readonly
    '%m', -- modified
    ' %{v:lua.require("config.statusline").git_branch()}',
    '%=', -- separator
    '%{&filetype}', -- filetype
    ' %3l:%-2c ', -- line:column
    ' %2p%%', -- percent through file
  }, '')
end

vim.cmd 'highlight StatusLineNormal guifg=#ffffff guibg=#005f87'
vim.cmd 'highlight StatusLineInsert guifg=#ffffff guibg=#5f8700'
vim.cmd 'highlight StatusLineVisual guifg=#ffffff guibg=#d75f00'
vim.cmd 'highlight StatusLineCommand guifg=#ffffff guibg=#87005f'
vim.cmd 'highlight StatusLineReplace guifg=#ffffff guibg=#af0000'
vim.cmd 'highlight StatusLineTerminal guifg=#ffffff guibg=#44475a'

vim.o.statusline = '%!v:lua.require("config.statusline").statusline()'

return M
