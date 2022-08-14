local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn
-- ensure that packer is installed
local install_path = fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
  execute "packadd packer.nvim"
end
vim.cmd "packadd packer.nvim"
local packer = require "packer"
local util = require "packer.util"
packer.init {
  package_root = util.join_paths(vim.fn.stdpath "data", "site", "pack"),
}
--- startup and add configure plugins
packer.startup(function()
  local use = use
  use {
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/plenary.nvim" } },
  }
  use { "nvim-telescope/telescope-dap.nvim" }
  use { "nvim-telescope/telescope-file-browser.nvim" }
  use {
    "nvim-treesitter/nvim-treesitter",
    run = function()
      require("nvim-treesitter.install").update { with_sync = true }
    end,
  }
  use "lewis6991/gitsigns.nvim"

  -- completion
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/cmp-nvim-lua"
  use "hrsh7th/cmp-nvim-lsp"
  use "saadparwaiz1/cmp_luasnip"
  use "L3MON4D3/LuaSnip"

  use "mfussenegger/nvim-dap"
  use "mfussenegger/nvim-dap-python"
  use "leoluz/nvim-dap-go"
  use "mxsdev/nvim-dap-vscode-js"
  use {
    "microsoft/vscode-js-debug",
    opt = true,
    run = "npm install --legacy-peer-deps && npm run compile" 
  }
  use "simrat39/rust-tools.nvim"
  use "rcarriga/nvim-dap-ui"

  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use "neovim/nvim-lspconfig"
  use "mfussenegger/nvim-lint"
  use "mhartington/formatter.nvim"

  use "kyazdani42/nvim-web-devicons"
  use {"akinsho/toggleterm.nvim", tag = 'v2.*', config = function()
    require("toggleterm").setup()
  end}
  use "akinsho/bufferline.nvim"
  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }
  use "windwp/nvim-ts-autotag"
  use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}
end)
require "es.globals"
