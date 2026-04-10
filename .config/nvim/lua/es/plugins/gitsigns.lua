local M = {}

function M.setup()
  require("gitsigns").setup({
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      require("es.keymaps").setup_gitsigns_keymaps(gs, bufnr)
    end,
  })
end

return M
