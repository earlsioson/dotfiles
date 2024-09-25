local has_nvim_treesitter_configs, nvim_treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not has_nvim_treesitter_configs then
  return
end

local has_nvim_treesitter_install, nvim_treesitter_install = pcall(require, "nvim-treesitter.install")
if not has_nvim_treesitter_install then
  return
end

nvim_treesitter_install.compilers = { "clang" }

nvim_treesitter_configs.setup {
  autotag = {
    enable = true,
  },
  ensure_installed = {
    "c", "cpp", "css", "dockerfile", "go", "hcl", "html", "javascript",
    "json", "markdown", "markdown_inline", "proto", "python", "regex", "rust", "swift", "toml", "tsx", "typescript", "yaml",
    "lua", "vim", "vimdoc", "query"
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true,
    disable = {
      "yaml",
      "markdown",
      "markdown_inline",
    }
  }
}
