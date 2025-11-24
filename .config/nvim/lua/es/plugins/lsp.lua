-- LSP servers managed by Mason
-- Individual server configurations live in ~/.config/nvim/lua/es/lsp/*.lua
-- and are loaded by this file.
local servers = {
  "biome",
  "cssls",
  "docker_compose_language_service",
  "dockerls",
  "gopls",
  "html",
  "jsonls",
  "lua_ls",

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
    cmd = "Mason",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
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
    event = { "BufReadPre", "BufNewFile" },
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

      -- Setup keymaps on LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("es_lsp_attach", { clear = true }),
        callback = function(args)
          require("es.keymaps").setup_lsp_keymaps(args.buf)
        end,
      })

      -- Enable LSP servers with completion capabilities
      -- Server-specific config is loaded from lua/es/lsp/*.lua files
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      for _, server in ipairs(servers) do
        local opts = {
          capabilities = capabilities,
        }

        -- Try to load server-specific config
        local ok, settings = pcall(require, "es.lsp." .. server)
        if ok and type(settings) == "table" then
          opts = vim.tbl_deep_extend("force", opts, settings)
        end

        -- Modern 0.11+ configuration
        vim.lsp.config[server] = opts
        vim.lsp.enable(server)
      end
    end,
  },
}
