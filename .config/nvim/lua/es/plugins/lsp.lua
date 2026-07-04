-- LSP servers managed by Mason
-- Optional server-specific overrides live in ~/.config/nvim/lua/es/lsp/*.lua.
-- Installed by Mason (npm/go/binary — none need pip/venv, so all work on
-- Lightning studios where venv creation is blocked).
local mason_servers = {
  "biome",
  "copilot",
  "cssls",
  "docker_compose_language_service",
  "dockerls",
  "gopls",
  "html",
  "jsonls",
  "lua_ls",
  "pyright",
  "rust_analyzer",
  "tailwindcss",
  "terraformls",
  "ts_ls",
  "vimls",
  "yamlls",
}

-- Provided outside Mason (static binary on PATH via ~/.local/bin, or uv) —
-- Mason would pip/venv these, which Lightning blocks. Configured + enabled,
-- but not ensure_installed.
local external_servers = {
  "ruff",
}

-- All servers get configured + enabled; only mason_servers get ensure_installed.
local servers = {}
vim.list_extend(servers, mason_servers)
vim.list_extend(servers, external_servers)

local M = {}

function M.setup()
  require("mason-lspconfig").setup({
    ensure_installed = mason_servers,
  })

  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    opts.max_width = opts.max_width or 80
    opts.max_height = opts.max_height or 30
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end

  vim.diagnostic.config({
    float = { border = "rounded" },
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("es_lsp_attach", { clear = true }),
    callback = function(args)
      require("es.keymaps").setup_lsp_keymaps(args.buf)

      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local inline_method = vim.lsp.protocol.Methods.textDocument_inlineCompletion
      if client and vim.lsp.inline_completion and inline_method and client:supports_method(inline_method, args.buf) then
        vim.lsp.inline_completion.enable(true, { bufnr = args.buf })
      end
    end,
  })

  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  for _, server in ipairs(servers) do
    local opts = {
      capabilities = capabilities,
    }

    local ok, settings = pcall(require, "es.lsp." .. server)
    if ok and type(settings) == "table" then
      opts = vim.tbl_deep_extend("force", opts, settings)
    end

    vim.lsp.config[server] = opts
    vim.lsp.enable(server)
  end
end

return M
