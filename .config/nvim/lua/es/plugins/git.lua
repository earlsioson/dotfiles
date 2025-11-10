return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ args = "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end, "Next hunk")

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ args = "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end, "Prev hunk")

          map("n", "<Leader>hs", gitsigns.stage_hunk, "Stage hunk")
          map("n", "<Leader>hr", gitsigns.reset_hunk, "Reset hunk")
          map("v", "<Leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, "Stage visual hunk")
          map("v", "<Leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, "Reset visual hunk")
          map("n", "<Leader>hS", gitsigns.stage_buffer, "Stage buffer")
          map("n", "<Leader>hu", gitsigns.undo_stage_hunk, "Undo stage hunk")
          map("n", "<Leader>hR", gitsigns.reset_buffer, "Reset buffer")
          map("n", "<Leader>hp", gitsigns.preview_hunk, "Preview hunk")
          map("n", "<Leader>hb", function()
            gitsigns.blame_line({ full = true })
          end, "Blame line")
          map("n", "<Leader>tb", gitsigns.toggle_current_line_blame, "Toggle line blame")
          map("n", "<Leader>hd", gitsigns.diffthis, "Diff against index")
          map("n", "<Leader>hD", function()
            gitsigns.diffthis("~")
          end, "Diff against ~")
          map("n", "<Leader>td", gitsigns.toggle_deleted, "Toggle deleted")
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
        end,
      })
    end,
  },
}
