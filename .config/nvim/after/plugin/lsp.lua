local has_lspconfig, lspconfig = pcall(require, "lspconfig")
if not has_lspconfig then
  return
end


local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not has_cmp_nvim_lsp then
  return
end

vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Setup lspconfig.
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
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

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
lspconfig.lua_ls.setup {
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
}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.lua" },
  callback = function()
    vim.lsp.buf.format()
  end,
})
lspconfig.gopls.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.go" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

lspconfig.pyright.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.py" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

lspconfig.terraformls.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

lspconfig.tsserver.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
}

lspconfig.eslint.setup {
  root_dir = lspconfig.util.root_pattern(
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    '.eslintrc.json',
    'package.json'
  )
}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  command = "EslintFixAll"
})

lspconfig.taplo.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
}

lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.rs" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

lspconfig.yamlls.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
  settings = {
    yaml = {
      keyOrdering = false
    }
  }
}

lspconfig.jsonls.setup {
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
}

lspconfig.dockerls.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
}

lspconfig.docker_compose_language_service.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
}

lspconfig.zls.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  handlers = handlers,
}
