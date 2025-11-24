return {
  { "tpope/vim-surround", event = "VeryLazy" },
  { "tpope/vim-unimpaired", event = "VeryLazy" },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
  },
  {
    "fatih/vim-go",
    ft = { "go" },
    build = ":GoUpdateBinaries",
  },
  { "terrastruct/d2-vim" },
  { "nordtheme/vim" },
  { "dracula/vim",       name = "dracula" },
  {
    "github/copilot.vim",
    cmd = { "Copilot" }
  }
}
