vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig',
}

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

vim.lsp.config('pyright', {
  before_init = function(_, config)
    local venv = vim.fs.find('.venv', { path = config.root_dir, upward = false, type = 'directory' })[1]
    if venv then
      config.settings.python.pythonPath = venv .. '/bin/python'
    end
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'off',
        diagnosticSeverityOverrides = {
          reportMissingImports = 'error',
          reportMissingModuleSource = 'none',
          reportMissingTypeStubs = 'none',
        },
      },
    },
  },
})

vim.lsp.config('ruff', {
  init_options = {
    settings = {
      organizeImports = false,
    },
  },
  capabilities = {
    textDocument = {
      formatting = vim.NIL,
      rangeFormatting = vim.NIL,
    },
  },
})

vim.lsp.enable { 'lua_ls', 'vtsls', 'tailwindcss', 'pyright', 'ruff' }

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Keymaps
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gd', vim.lsp.buf.definition, 'Go to definition')
    map('<leader>ca', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Highlight references on hover
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight-' .. event.buf, { clear = true })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          pcall(vim.api.nvim_del_augroup_by_name, 'lsp-highlight-' .. event2.buf)
        end,
      })
    end
  end,
})
