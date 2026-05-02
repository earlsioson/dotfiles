local M = {}

function M.setup()
  require("which-key").setup({
    preset = "modern",
    delay = 300,
    spec = {
      { "<leader>l", group = "LSP" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>b", group = "Debug" },
      { "<leader>d", group = "Diagnostics" },
      { "<leader>h", group = "Git Hunks" },
      { "<leader>e", group = "Explorer" },
      { "<leader>t", group = "Toggle" },
      { "<leader>m", group = "Markdown" },
      { "<leader>A", group = "AI" },
    },
  })
end

return M
