if not pcall(require, "nvim_treesitter.configs") then
  return
end

require'nvim-treesitter.configs'.setup {
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
