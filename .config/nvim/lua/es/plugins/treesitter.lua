return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local configs = require("nvim-treesitter.configs")
      local install = require("nvim-treesitter.install")
      install.compilers = { "clang" }
      install.prefer_git = true

      configs.setup({
        autotag = {
          enable = true,
        },
        ensure_installed = {
          "c",
          "cpp",
          "css",
          "dockerfile",
          "go",
          "hcl",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "proto",
          "python",
          "regex",
          "rust",
          "swift",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
          "query",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = true,
        },
        indent = {
          enable = true,
          disable = { "yaml", "markdown", "markdown_inline" },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true,
      max_lines = 1,
    },
    keys = {
      {
        "<Leader>x",
        function()
          require("treesitter-context").go_to_context()
        end,
        desc = "Treesitter context jump",
      },
    },
  },
}
