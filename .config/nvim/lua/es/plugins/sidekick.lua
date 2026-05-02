local M = {}

function M.setup()
  require("sidekick").setup({
    cli = {
      mux = {
        -- Keep Sidekick CLI sessions persistent when Neovim runs inside tmux.
        enabled = vim.env.TMUX ~= nil,
        backend = "tmux",
      },
    },
  })
end

return M
