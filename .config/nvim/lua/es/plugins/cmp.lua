local M = {}

function M.setup()
  local cmp = require("cmp")

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.snippet.expand(args.body)
      end,
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local icon = require("mini.icons").get("lsp", vim_item.kind)
        vim_item.kind = string.format("%s %s", icon, vim_item.kind)
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          buffer = "[Buffer]",
          path = "[Path]",
        })[entry.source.name]
        return vim_item
      end,
    },
    -- Menu navigation stays on preset.insert's keys, which mirror Neovim's native
    -- ins-completion: <C-n>/<C-p> to cycle, <C-y> to accept, <C-e> to abort, plus
    -- the arrows. Default-first: do not add <Tab> here. Insert-mode <Tab> belongs to
    -- the inline-completion/snippet chain in keymaps.lua.
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "path" },
    }, {
      { name = "buffer", keyword_length = 3 },
    }),
  })

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
  })

  vim.keymap.set({ "i", "s" }, "<C-f>", function()
    if vim.snippet.active({ direction = 1 }) then
      return vim.snippet.jump(1)
    end
  end, { silent = true, desc = "Snippet jump next" })

  vim.keymap.set({ "i", "s" }, "<C-b>", function()
    if vim.snippet.active({ direction = -1 }) then
      return vim.snippet.jump(-1)
    end
  end, { silent = true, desc = "Snippet jump previous" })
end

return M
