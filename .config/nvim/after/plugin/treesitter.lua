local has_nvim_treesitter_configs, nvim_treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not has_nvim_treesitter_configs then
  return
end

nvim_treesitter_configs.setup {
  autotag = {
    enable = true,
  },
  ensure_installed = {
    "c", "cpp", "css", "dockerfile", "go", "hcl", "html", "javascript",
    "json", "lua", "markdown", "proto", "python", "regex", "rust", "swift", "toml", "tsx", "typescript", "yaml"
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true }
}
