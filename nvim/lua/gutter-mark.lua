local M = {}

vim.fn.sign_define('GutterMark', { text = '●', texthl = 'WarningMsg', numhl = '' })

-- Global marks table
M.global_marks = {}

-- Helper: get next free mark letter (a-z)
local function get_free_mark()
  local used = {}
  for _, m in ipairs(M.global_marks) do
    used[m.mark] = true
  end
  for c = string.byte 'a', string.byte 'z' do
    local letter = string.char(c)
    if not used[letter] then return letter end
  end
  return nil
end

-- Sort marks by buffer number, then line
local function sort_marks()
  table.sort(M.global_marks, function(a, b)
    if a.bufnr == b.bufnr then
      return a.line < b.line
    else
      return a.bufnr < b.bufnr
    end
  end)
end

-- Toggle mark at current line
function M.toggle_mark()
  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1]

  -- Remove existing mark at this line
  for i, m in ipairs(M.global_marks) do
    if m.bufnr == bufnr and m.line == line then
      vim.cmd('delmarks ' .. m.mark)
      vim.fn.sign_unplace('gutter_mark', { buffer = bufnr, id = line })
      table.remove(M.global_marks, i)
      print("Removed mark '" .. m.mark .. "' from line " .. line)
      return
    end
  end

  -- Place new mark
  local mark = get_free_mark()
  if not mark then
    print 'No free marks (a-z) available'
    return
  end

  vim.cmd('mark ' .. mark)
  vim.fn.sign_place(line, 'gutter_mark', 'GutterMark', bufnr, { lnum = line })
  table.insert(M.global_marks, { bufnr = bufnr, line = line, mark = mark })
  sort_marks()

  print("Placed mark '" .. mark .. "' in buffer " .. bufnr .. ' at line ' .. line)
end

-- Jump to a mark by letter
function M.jump_to_mark()
  local mark = vim.fn.input 'Jump to mark (a-z): '
  if mark:match '^[a-z]$' then
    vim.cmd("normal! '" .. mark)
  else
    print 'Invalid mark'
  end
end

-- Clear all marks
function M.clear_marks()
  for _, m in ipairs(M.global_marks) do
    vim.cmd('delmarks ' .. m.mark)
    vim.fn.sign_unplace('gutter_mark', { buffer = m.bufnr })
  end
  M.global_marks = {}
end

-- Next mark (cyclic, ordered)
function M.next_mark()
  local cur_buf = vim.api.nvim_get_current_buf()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  if #M.global_marks == 0 then return end

  for _, m in ipairs(M.global_marks) do
    if m.bufnr > cur_buf or (m.bufnr == cur_buf and m.line > cur_line) then
      vim.api.nvim_set_current_buf(m.bufnr)
      vim.api.nvim_win_set_cursor(0, { m.line, 0 })
      return
    end
  end
  -- wrap to first mark
  local m = M.global_marks[1]
  vim.api.nvim_set_current_buf(m.bufnr)
  vim.api.nvim_win_set_cursor(0, { m.line, 0 })
end

-- Previous mark (cyclic, ordered)
function M.prev_mark()
  local cur_buf = vim.api.nvim_get_current_buf()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  if #M.global_marks == 0 then return end

  for i = #M.global_marks, 1, -1 do
    local m = M.global_marks[i]
    if m.bufnr < cur_buf or (m.bufnr == cur_buf and m.line < cur_line) then
      vim.api.nvim_set_current_buf(m.bufnr)
      vim.api.nvim_win_set_cursor(0, { m.line, 0 })
      return
    end
  end
  -- wrap to last mark
  local m = M.global_marks[#M.global_marks]
  vim.api.nvim_set_current_buf(m.bufnr)
  vim.api.nvim_win_set_cursor(0, { m.line, 0 })
end

vim.keymap.set('n', '<Leader>m', M.toggle_mark, { silent = true, desc = 'Toggle gutter mark' })
vim.keymap.set('n', '<Leader>cm', M.clear_marks, { silent = true, desc = 'Clear all gutter marks' })
vim.keymap.set('n', ']m', M.next_mark, { silent = true, desc = 'Jump to next global mark' })
vim.keymap.set('n', '[m', M.prev_mark, { silent = true, desc = 'Jump to previous global mark' })

return M
