local has_mason, mason = pcall(require, "mason")
if not has_mason then
  return
end

local has_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if not has_mason_lspconfig then
  return
end

local has_mason_dap, mason_dap = pcall(require, "mason-nvim-dap")
if not has_mason_dap then
  return
end

mason_dap.setup {
  ensure_installed = {
    "codelldb",
    "debugpy",
    "delve",
    "js-debug-adapter",
  },
}

mason.setup()
mason_lspconfig.setup {
  ensure_installed = {
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
  },
}
