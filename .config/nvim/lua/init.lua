local vim = vim

require "es.globals"

if vim.env.TMUX then
  vim.g.clipboard = {
    name = 'tmux',
    copy = {
      ["+"] = { 'tmux', 'load-buffer', '-w', '-' },
      ["*"] = { 'tmux', 'load-buffer', '-w', '-' },
    },
    paste = {
      ["+"] = { 'bash', '-c', 'tmux refresh-client -l && sleep 0.2 && tmux save-buffer -' },
      ["*"] = { 'bash', '-c', 'tmux refresh-client -l && sleep 0.2 && tmux save-buffer -' },
    },
    cache_enabled = false,
  }
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
local plugins = {
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-nvim-lsp",
  "saadparwaiz1/cmp_luasnip",
  "L3MON4D3/LuaSnip",
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
  "mfussenegger/nvim-dap-python",
  "leoluz/nvim-dap-go",
  "mxsdev/nvim-dap-vscode-js",
  {
    "microsoft/vscode-js-debug",
    lazy = true,
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    dependencies = { "tami5/sqlite.lua" }
  },
  { "nvim-telescope/telescope-file-browser.nvim" },
  { "nvim-telescope/telescope-live-grep-args.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim",    build = "make" },
  "kyazdani42/nvim-web-devicons",
  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end
  },
  "folke/tokyonight.nvim",
  {
    'nvim-tree/nvim-tree.lua',
  },
  "tpope/vim-surround",
  "tpope/vim-unimpaired",
  "tpope/vim-fugitive",
  "airblade/vim-gitgutter",
  "arcticicestudio/nord-vim",
  { "dracula/vim",  name = "dracula" },
  { "fatih/vim-go", build = ":GoUpdateBinaries" },
  "github/copilot.vim",
  "dense-analysis/ale",
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  "ziglang/zig.vim",
}
require("lazy").setup(plugins)
