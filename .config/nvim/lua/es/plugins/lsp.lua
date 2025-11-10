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

-- LSP keymaps are now centralized in es.keymaps
-- This ensures they work even when LSP hasn't attached yet

local function on_lsp_attach(event)
  local bufnr = event.buf
  vim.bo[bufnr].omnifunc = nil
  -- Buffer-local keymaps are handled in es.keymaps
end

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
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,
          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  runtime = {
                    version = "LuaJIT",
                  },
                  diagnostics = {
                    globals = { "vim" },
                  },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                  },
                  telemetry = {
                    enable = false,
                  },
                },
              },
            })
          end,
        },
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
    event = { "BufNewFile", "BufReadPre" },
    config = function()
      vim.diagnostic.config({
        float = { border = "single" },
      })

      -- Configure lua_ls using the built-in vim.lsp.config API
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("es_lsp_attach", { clear = true }),
        callback = on_lsp_attach,
      })
    end,
  },
}
