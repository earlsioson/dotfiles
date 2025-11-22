return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 300,
      spec = {
        -- Main leader groups
        { "<leader>l", group = "LSP", icon = " " },
        { "<leader>f", group = "Find", icon = "🔍" },
        { "<leader>g", group = "Git", icon = " " },
        { "<leader>b", group = "Debug", icon = " " },
        { "<leader>d", group = "Diagnostics", icon = " " },
        { "<leader>h", group = "Git Hunks", icon = " " },
        { "<leader>n", group = "NvimTree", icon = " " },
        { "<leader>t", group = "Toggle", icon = " " },
        { "<leader>m", group = "Markdown", icon = " " },

        -- LSP operations
        { "<leader>la", desc = "Code action" },
        { "<leader>lc", desc = "Incoming calls" },
        { "<leader>lC", desc = "Outgoing calls" },
        { "<leader>ld", desc = "Definition" },
        { "<leader>lD", desc = "Declaration" },
        { "<leader>lf", desc = "Format" },
        { "<leader>lh", desc = "Hover" },
        { "<leader>li", desc = "Implementation" },
        { "<leader>lo", desc = "Document outline" },
        { "<leader>lr", desc = "References" },
        { "<leader>ln", desc = "Rename" },
        { "<leader>ls", desc = "Signature help" },
        { "<leader>lt", desc = "Type definition" },
        { "<leader>lw", desc = "Workspace symbols" },

        -- Find operations
        { "<leader>ff", desc = "Find files" },
        { "<leader>fr", desc = "Find with ripgrep (live grep)" },
        { "<leader>fb", desc = "Find buffers" },
        { "<leader>fg", desc = "Find git files" },
        { "<leader>fo", desc = "Find oldfiles (recent)" },
        { "<leader>fh", desc = "Find hidden files (including gitignored)" },
        { "<leader>fw", desc = "Find workspace symbols" },
        { "<leader>fd", desc = "Find document symbols" },
        { "<leader>fk", desc = "Find keymaps" },
        { "<leader>fe", desc = "Find explorer (file browser)" },
        { "<leader>fE", desc = "Find explorer all (no gitignore)" },
        { "<leader>fD", desc = "Oil open directory (finder)" },

        -- Git operations
        { "<leader>gg", desc = "Git status" },
        { "<leader>hs", desc = "Stage hunk" },
        { "<leader>hr", desc = "Reset hunk" },
        { "<leader>hS", desc = "Stage buffer" },
        { "<leader>hR", desc = "Reset buffer" },
        { "<leader>hu", desc = "Undo stage hunk" },
        { "<leader>hp", desc = "Preview hunk" },
        { "<leader>hi", desc = "Preview hunk inline" },
        { "<leader>hb", desc = "Blame line" },
        { "<leader>hd", desc = "Diff this" },
        { "<leader>hD", desc = "Diff this ~" },
        { "<leader>hQ", desc = "Quickfix all hunks" },
        { "<leader>hq", desc = "Quickfix hunks" },

        -- Debug operations
        { "<leader>bc", desc = "Continue" },
        { "<leader>bb", desc = "Toggle breakpoint" },
        { "<leader>bB", desc = "Conditional breakpoint" },
        { "<leader>bs", desc = "Step over" },
        { "<leader>bi", desc = "Step into" },
        { "<leader>bo", desc = "Step out" },
        { "<leader>bt", desc = "Terminate" },
        { "<leader>br", desc = "REPL" },
        { "<leader>bu", desc = "Toggle UI" },
        { "<leader>bv", desc = "Load vscode config" },
        { "<leader>bl", desc = "Run last" },
        { "<leader>bk", desc = "Clear all breakpoints" },
        { "<leader>bh", desc = "Hover variables" },
        { "<leader>bw", desc = "Watches" },
        { "<leader>bf", desc = "Frames" },
        { "<leader>bp", desc = "Preview scopes" },

        -- Diagnostics
        { "<leader>df", desc = "Float" },
        { "<leader>dl", desc = "Location list" },
        { "<leader>dq", desc = "Quickfix" },

        -- Toggle operations
        { "<leader>tb", desc = "Toggle current line blame" },
        { "<leader>tw", desc = "Toggle word diff" },

        -- NvimTree
        { "<leader>nt", desc = "Toggle" },
        { "<leader>nf", desc = "Find file" },
        { "<leader>nc", desc = "Close" },
        { "<leader>np", desc = "Open parent directory" },

        -- Markdown
        { "<leader>mp", desc = "Preview" },

        -- Navigation hints
        { "]c", desc = "Next git hunk" },
        { "[c", desc = "Previous git hunk" },
        { "]d", desc = "Next diagnostic" },
        { "[d", desc = "Previous diagnostic" },

        -- Oil
        { "-", desc = "Oil parent directory" },

        -- Shared vim keymaps
        { "<leader>n", desc = "New buffer" },
        { "<leader>a", desc = "Alternate buffer" },
        { "<leader>k", desc = "Clear search highlight" },
        { "<leader>y", desc = "Yank to system clipboard" },
        { "<leader><leader>t", desc = "Small terminal" },
        { "<leader><leader>x", desc = "Execute current file" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },
}
