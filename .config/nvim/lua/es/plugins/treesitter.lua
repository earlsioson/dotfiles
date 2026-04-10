local M = {}

local languages = {
  "c",
  "cpp",
  "css",
  "dockerfile",
  "go",
  "hcl",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "proto",
  "python",
  "regex",
  "rust",
  "swift",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "query",
}

local indent_disabled = {
  markdown = true,
  markdown_inline = true,
  yaml = true,
}

local ft_to_lang = {
  ["markdown.mdx"] = "markdown",
  typescriptreact = "tsx",
}

function M.setup()
  require("nvim-treesitter").setup({})
  require("nvim-treesitter").install(languages, { summary = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("es_treesitter_filetype", { clear = true }),
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      local lang = ft_to_lang[ft] or ft

      if not vim.list_contains(languages, lang) then
        return
      end

      pcall(vim.treesitter.start, args.buf, lang)
      vim.wo[vim.fn.bufwinid(args.buf)].foldmethod = "expr"
      vim.wo[vim.fn.bufwinid(args.buf)].foldexpr = "v:lua.vim.treesitter.foldexpr()"

      if not indent_disabled[lang] then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })

  require("treesitter-context").setup({
    enable = true,
    max_lines = 3,
  })
end

return M
