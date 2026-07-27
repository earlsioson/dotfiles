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

-- Provided outside Mason (static binary on PATH, or uv) — Mason would
-- pip/venv these, which Lightning blocks. Each entry maps a server to the
-- executable it spawns; a server whose binary is absent is skipped entirely,
-- so opening its filetype never attempts to launch a missing process. This is
-- what keeps the config portable: mojo ships only for Apple silicon macOS and
-- Ubuntu, and stays silent everywhere else.
local external_servers = {
  denols = "deno",
  mojo = "mojo-lsp-server",
  ols = "ols",
  ruff = "ruff",
  zls = "zls",
}

-- Servers whose executable may be installed per-project (a uv venv) instead of
-- globally, so a PATH probe here would answer for the wrong directory: this
-- runs once, when the first file of the session is opened, and the answer is
-- cached for every buffer after it. These are enabled unconditionally and
-- their `es.lsp.<server>` module owns both resolving the executable and
-- deciding, per buffer, whether to activate at all (see |lsp-root_dir()|).
local project_local_servers = {
  mojo = true,
}

-- All configured servers get enabled; only mason_servers get ensure_installed.
local servers = {}
vim.list_extend(servers, mason_servers)
for server, executable in pairs(external_servers) do
  if project_local_servers[server] or vim.fn.executable(executable) == 1 then
    table.insert(servers, server)
  end
end

local M = {}

-- Exported so tooling outside this repository can read the contract instead of
-- duplicating it: these are the executables that must already exist on PATH,
-- and af-workspace's `just doctor` reports any that are missing. Entries in
-- project_local_servers are the exception — they may instead live in a
-- project's `.venv/bin`, so a missing PATH entry there is not a defect.
M.external_servers = external_servers
M.project_local_servers = project_local_servers

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
