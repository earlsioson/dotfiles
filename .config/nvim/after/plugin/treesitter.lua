local has_nvim_treesitter_configs, nvim_treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not has_nvim_treesitter_configs then
  return
end

nvim_treesitter_configs.setup {
  autotag = {
    enable = true,
  },
  ensure_installed = {
    "cpp", "css", "dockerfile", "go", "hcl", "html", "javascript",
    "json", "markdown", "proto", "python", "regex", "rust", "swift", "toml", "tsx", "typescript", "yaml",
    "lua", "vim"
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true }
}
