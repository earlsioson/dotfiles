local M = {}

function M.setup()
  require("sidekick").setup({
    nes = {
      enabled = false,
    },
    cli = {
      picker = "telescope",
      win = {
        layout = "right",
        split = {
          width = 88,
        },
      },
      mux = {
        enabled = vim.env.TMUX ~= nil,
        backend = "tmux",
        create = "terminal",
      },
    },
    copilot = {
      status = {
        enabled = false,
      },
    },
  })
end

return M
