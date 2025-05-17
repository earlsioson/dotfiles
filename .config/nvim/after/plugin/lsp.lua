vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
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
    vim.keymap.set('n', '<Leader>lf', vim.lsp.buf.format, bufopts)
    vim.keymap.set('n', '<Leader>lw', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<Leader>lW', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<Leader>ll', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<Leader>lt', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<Leader>ln', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<Leader>la', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<Leader>lA',"<Cmd>LspTypescriptSourceAction<CR>", bufopts)
    vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<Leader>=', function()
      vim.lsp.buf.format { async = true }
    end, opts)
    vim.keymap.set('n', '<Leader>lI', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, opts)
  end,
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'use' }
      }
    }
  }
})
