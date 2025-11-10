return {
  "folke/flash.nvim",
  keys = {
    { "<Leader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
    { "<Leader>S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Flash remote" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Flash treesitter search" },
    { "<C-s>", mode = "c", function() require("flash").toggle() end, desc = "Flash toggle search" },
  },
  opts = {},
}

