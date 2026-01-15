return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Main source for code
      "hrsh7th/cmp-buffer",   -- Text in current buffer
      "hrsh7th/cmp-path",     -- File paths
      "hrsh7th/cmp-cmdline",  -- Command line completions
    },
    config = function()
      local cmp = require("cmp")

      -- Improve visibility of the completion menu
      -- We use Pmenu for a more distinct background and a brighter border color
      vim.api.nvim_set_hl(0, "CmpNormal", { link = "Pmenu" })
      vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#7aa2f7" }) -- TokyoNight blue
      vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#7e8294", bg = "NONE", strikethrough = true })
      vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#82aaff", bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#82aaff", bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#c678dd", bg = "NONE", italic = true })

      cmp.setup({
        -- 1. Use Native Neovim Snippets (No LuaSnip required)
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },

        -- 2. Visuals
        window = {
          completion = {
            border = "rounded",
            winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
            side_padding = 1,
            col_offset = -3, -- Align with the cursor better
          },
          documentation = {
            border = "rounded",
            winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
          },
        },

        -- Formatting for a more "premium" look with icons
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local icon, _, _ = require("mini.icons").get("lsp", vim_item.kind)
            vim_item.kind = string.format("%s %s", icon, vim_item.kind)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },

        -- 3. Mappings
        -- We use preset.insert to get standard defaults:
        -- <C-n>: Next item
        -- <C-p>: Previous item
        -- <C-y>: Accept (Native vim default, works alongside CR)
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(), -- Force trigger menu

          -- Accept with Enter.
          -- 'select = true' means if you hit Enter without selecting, it picks the first one.
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),

        -- 4. Sources (Cleaned up)
        sources = cmp.config.sources({
          { name = "nvim_lsp" },                   -- Code intelligence
          { name = "path" },                       -- Filesystem paths
        }, {
          { name = "buffer", keyword_length = 3 }, -- Text in file (fallback)
        }),
      })

      -- Setup for / search
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      -- Setup for : commands
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })

      -- OPTIONAL: Native Snippet Jumping
      -- Since we removed LuaSnip, you need a way to jump between arguments
      -- if LSP fills in a function like: my_func(|arg1|, arg2)
      vim.keymap.set({ "i", "s" }, "<C-f>", function()
        if vim.snippet.active({ direction = 1 }) then
          return vim.snippet.jump(1)
        end
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<C-b>", function()
        if vim.snippet.active({ direction = -1 }) then
          return vim.snippet.jump(-1)
        end
      end, { silent = true })
    end,
  },
}
