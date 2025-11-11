return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local keymaps = require('es.keymaps')
        keymaps.setup_gitsigns_keymaps(gs, bufnr)
      end
    },
  },
}
