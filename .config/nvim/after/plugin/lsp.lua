local has_cmp, cmp = pcall(require, "cmp")
if not has_cmp then
  return
end

local has_luasnip, luasnip = pcall(require, "luasnip")
if not has_luasnip then
  return
end

local has_lspconfig, lspconfig = pcall(require, "lspconfig")
if not has_lspconfig then
  return
end


local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not has_cmp_nvim_lsp then
  return
end

vim.opt.completeopt = { "menu", "menuone", "noselect" }

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-B>'] = cmp.mapping.scroll_docs( -4),
    ['<C-F>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-E>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'buffer',  keyword_length = 5 },
  }),
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  }
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

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

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <C-X><C-O>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
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
  vim.keymap.set('n', '<Leader>lf', vim.lsp.buf.formatting, bufopts)
end

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
  on_attach = on_attach,
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
  callback = vim.lsp.buf.formatting_sync,
})
lspconfig.gopls.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  on_attach = on_attach,
  handlers = handlers,
}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.go" },
  callback = vim.lsp.buf.formatting_sync,
})

lspconfig.pyright.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  on_attach = on_attach,
  handlers = handlers,
}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.py" },
  callback = vim.lsp.buf.formatting_sync,
})

lspconfig.terraformls.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  on_attach = on_attach,
  handlers = handlers,
}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = vim.lsp.buf.formatting_sync,
})

lspconfig.tsserver.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  on_attach = on_attach,
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
  on_attach = on_attach,
  handlers = handlers,
}

lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  on_attach = on_attach,
  handlers = handlers,
}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.rs" },
  callback = vim.lsp.buf.formatting_sync,
})

lspconfig.yamlls.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  on_attach = on_attach,
  handlers = handlers,
}

lspconfig.jsonls.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  on_attach = on_attach,
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
  on_attach = on_attach,
  handlers = handlers,
}

lspconfig.docker_compose_language_service.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  on_attach = on_attach,
  handlers = handlers,
}
