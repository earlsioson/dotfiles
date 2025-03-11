local has_mason, mason = pcall(require, "mason")
if not has_mason then
  return
end

local has_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if not has_mason_lspconfig then
  return
end

mason.setup()
mason_lspconfig.setup {
  ensure_installed = {
    "bashls",
    "biome",
    "clangd",
    "cmake",
    "docker_compose_language_service",
    "dockerls",
    "glsl_analyzer",
    "gopls",
    "jsonls",
    "lua_ls",
    "pyright",
    "ruff",
    "rust_analyzer",
    "tailwindcss",
    "taplo",
    "terraformls",
    "ts_ls",
    "vimls",
    "wgsl_analyzer",
    "yamlls",
    "zls",
  },
}
