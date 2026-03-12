-- Enhanced search functionality with inline count display

-- Create namespace and augroup
local search_ns = vim.api.nvim_create_namespace('search_count')
local search_group = vim.api.nvim_create_augroup('search_count', { clear = true })
local search_extmark_id = nil

local function clear_search_count()
  if search_extmark_id then
    vim.api.nvim_buf_del_extmark(0, search_ns, search_extmark_id)
    search_extmark_id = nil
  end
end

local function show_search_count()
  clear_search_count()

  local ok, search_count = pcall(vim.fn.searchcount, { maxcount = 999 })
  if ok and search_count.total > 0 then
    local msg = string.format(' [%d/%d]', search_count.current, search_count.total)
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1

    search_extmark_id = vim.api.nvim_buf_set_extmark(0, search_ns, row, 0, {
      virt_text = { { msg, 'SpecialComment' } },
      virt_text_pos = 'eol',
    })
  end
end

-- Show search count after search
vim.api.nvim_create_autocmd('CmdlineLeave', {
  group = search_group,
  callback = function()
    if vim.v.event.cmdtype == '/' or vim.v.event.cmdtype == '?' then
      vim.defer_fn(show_search_count, 10)
    end
  end,
})

-- Show search count when navigating with n/N or moving cursor
vim.api.nvim_create_autocmd('CursorMoved', {
  group = search_group,
  callback = function()
    if vim.v.hlsearch == 1 then
      vim.defer_fn(show_search_count, 10)
    else
      clear_search_count()
    end
  end,
})

-- Setup keymaps with search count clearing
vim.keymap.set('n', '<Esc>', function()
  vim.cmd('nohlsearch')
  vim.api.nvim_buf_clear_namespace(0, search_ns, 0, -1)
end, { desc = 'Clear search highlights' })

vim.keymap.set('n', 'n', function()
  vim.cmd('normal! n')
end, { desc = 'Next search result' })

vim.keymap.set('n', 'N', function()
  vim.cmd('normal! N')
end, { desc = 'Previous search result' })
