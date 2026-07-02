local M = {}

function M.setup()
  -- Load telescope feature so that sidekick has a valid picker.
  require("es.pack").load("telescope")

  require("sidekick").setup({
    picker = "telescope",
    cli = {
      mux = {
        -- Keep Sidekick CLI sessions persistent when Neovim runs inside tmux.
        enabled = vim.env.TMUX ~= nil,
        backend = "tmux",
      },
      tools = {
        agy = {
          cmd = { "agy" },
        },
      },
      win = {
        keys = {
          stopinsert = { "<leader><Esc>", "stopinsert", mode = "t", desc = "Exit terminal mode" },
        },
      },
    },
  })
end

return M
