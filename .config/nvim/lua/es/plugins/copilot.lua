return {
  {
    "zbirenbaum/copilot.lua",
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
    -- Copilot keymaps are centralized in es.keymaps
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
