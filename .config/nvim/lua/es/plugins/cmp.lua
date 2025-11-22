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

      cmp.setup({
        -- 1. Use Native Neovim Snippets (No LuaSnip required)
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },

        -- 2. Visuals
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
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

          -- NOTICE: We removed <Tab>.
          -- This allows Augment to use <Tab> for AI completion.
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
