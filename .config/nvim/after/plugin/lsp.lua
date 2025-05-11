local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not has_cmp_nvim_lsp then
  return
end

vim.opt.completeopt = { "menu", "menuone", "noselect" }

local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
vim.diagnostic.config {
  float = { border = "single" },
}
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<Leader>do', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<Leader>dl', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '<Leader>ds', vim.diagnostic.show, opts)
vim.keymap.set('n', '<Leader>dh', vim.diagnostic.hide, opts)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = nil

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { buffer = ev.buf }
    vim.keymap.set('n', '<Leader>lD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', '<Leader>ld', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', '<Leader>lh', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<Leader>li', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<Leader>ls', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<Leader>lf', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<Leader>lF', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<Leader>ll', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<Leader>lt', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<Leader>ln', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<Leader>la', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<Leader>=', function()
      vim.lsp.buf.format { async = true }
    end, opts)
    vim.keymap.set('n', '<Leader>lI', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, opts)
  end,
})

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' }),
}

-- LSP settings (for overriding per client)
vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'use' }
      }
    }
  }
})
vim.lsp.enable({ 'lua_ls' })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.lua" },
  callback = function()
    vim.lsp.buf.format()
  end,
})
vim.lsp.config('gopls', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

vim.lsp.enable({ 'gopls' })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.go" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.lsp.config('ruff', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
})
vim.lsp.enable({ 'ruff' })
vim.lsp.config('pyright', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { '*' },
      },
    },
  },
})
vim.lsp.enable({ 'pyright' })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.py" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.lsp.config('terraformls', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
})
vim.lsp.enable({ 'terraformls' })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.lsp.config('ts_ls', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }
    }
  }
})
vim.lsp.enable({ 'ts_ls' })

vim.lsp.config('eslint', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
})
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
--   command = "EslintFixAll"
-- })
vim.lsp.enable({ 'eslint' })

vim.lsp.config('taplo', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
})
vim.lsp.enable({ 'taplo' })

vim.lsp.config('rust_analyzer', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy"
      }
    },
    inlayHints = {
      enable = true,
      showParameterNames = true,
      parameterHintsPrefix = "<- ",
      otherHintsPrefix = "=> ",
    },
  }
})
vim.lsp.enable({ 'rust_analyzer' })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.rs" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.lsp.config('yamlls', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
  settings = {
    yaml = {
      keyOrdering = false
    }
  }
})
vim.lsp.enable({ 'yamlls' })

vim.lsp.config('jsonls', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
  cmd = { vim.env.HOME .. "/.local/share/nvim/mason/bin/vscode-json-language-server", "--stdio" },
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
      end
    }
  }
})
vim.lsp.enable({ 'jsonls' })

vim.lsp.config('dockerls', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
})
vim.lsp.enable({ 'dockerls' })

vim.lsp.config('docker_compose_language_service', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
})
vim.lsp.enable({ 'docker_compose_language_service' })

vim.lsp.config('zls', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
})
vim.lsp.enable({ 'zls' })

vim.lsp.config('bashls', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
})
vim.lsp.enable({ 'bashls' })

vim.lsp.config('biome', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
})
vim.lsp.enable({ 'biome' })

vim.lsp.config('glsl_analyzer', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
})
vim.lsp.enable({ 'glsl_analyzer' })

vim.lsp.config('wgsl_analyzer', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
})
vim.lsp.enable({ 'wgsl_analyzer' })

vim.lsp.config('mojo', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
})
vim.lsp.enable({ 'mojo' })

vim.lsp.config('cmake', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
})
vim.lsp.enable({ 'cmake' })

vim.lsp.config('clangd', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
  },
})
vim.lsp.enable({ 'cland' })

vim.lsp.config('tailwindcss', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
})
vim.lsp.enable({ 'tailwindcss' })

vim.lsp.config('oxlint', {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
})
vim.lsp.enable({ 'oxlint' })
