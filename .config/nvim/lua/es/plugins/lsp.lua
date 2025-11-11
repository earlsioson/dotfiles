-- LSP servers managed by Mason
-- Individual server configurations live in ~/.config/nvim/lsp/*.lua
-- and are auto-discovered by Neovim 0.11's vim.lsp.config
local servers = {
  "cssls",
  "docker_compose_language_service",
  "dockerls",
  "gopls",
  "html",
  "jsonls",
  "lua_ls",
  "oxlint",
  "pyright",
  "ruff",
  "rust_analyzer",
  "tailwindcss",
  "terraformls",
  "ts_ls",
  "vimls",
  "yamlls",
}

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = servers,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Configure LSP floating window appearance
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        opts.max_width = opts.max_width or 80
        opts.max_height = opts.max_height or 30
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      -- Configure diagnostic floating window appearance
      vim.diagnostic.config({
        float = { border = "rounded" },
      })

      -- Enable LSP servers with completion capabilities
      -- Server-specific config is auto-discovered from lsp/*.lua files
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
      end
    end,
  },
}
