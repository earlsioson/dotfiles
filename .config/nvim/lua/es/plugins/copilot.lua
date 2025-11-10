return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
      },
      panel = {
        enabled = true,
      },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
    keys = {
      { "<Leader>ce", "<Cmd>Copilot enable<CR>", mode = "n", desc = "Copilot enable" },
      { "<Leader>cd", "<Cmd>Copilot disable<CR>", mode = "n", desc = "Copilot disable" },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
