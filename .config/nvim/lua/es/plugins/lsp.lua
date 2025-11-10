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

local function diagnostics_keymaps()
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<Leader>do", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<Leader>dl", vim.diagnostic.setloclist, opts)
  vim.keymap.set("n", "<Leader>ds", vim.diagnostic.show, opts)
  vim.keymap.set("n", "<Leader>dh", vim.diagnostic.hide, opts)
end

local function on_lsp_attach(event)
  local bufnr = event.buf
  vim.bo[bufnr].omnifunc = nil

  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("<Leader>lD", vim.lsp.buf.declaration, "LSP declaration")
  map("<Leader>ld", vim.lsp.buf.definition, "LSP definition")
  map("<Leader>lh", vim.lsp.buf.hover, "LSP hover")
  map("<Leader>li", vim.lsp.buf.implementation, "LSP implementation")
  map("<Leader>ls", vim.lsp.buf.signature_help, "Signature help")
  map("<Leader>lf", vim.lsp.buf.format, "Format buffer")
  map("<Leader>lw", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
  map("<Leader>lW", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
  map("<Leader>ll", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List workspace folders")
  map("<Leader>lt", vim.lsp.buf.type_definition, "Type definition")
  map("<Leader>ln", vim.lsp.buf.rename, "Rename symbol")
  map("<Leader>la", vim.lsp.buf.code_action, "Code action")
  map("<Leader>lA", "<Cmd>LspTypescriptSourceAction<CR>", "TypeScript source action")
  map("<Leader>lr", vim.lsp.buf.references, "References")
  map("<Leader>=", function()
    vim.lsp.buf.format({ async = true })
  end, "Async format")

  map("<Leader>lI", function()
    local inlay = vim.lsp.inlay_hint
    if inlay and inlay.is_enabled and inlay.enable then
      local enabled = inlay.is_enabled(bufnr)
      inlay.enable(not enabled, { bufnr = bufnr })
    end
  end, "Toggle inlay hints")
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
      diagnostics_keymaps()
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
