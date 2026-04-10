local M = {}

function M.setup()
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { "biome" },
      typescript = { "biome" },
      javascriptreact = { "biome" },
      typescriptreact = { "biome" },
      css = { "biome" },
      html = { "biome" },
      json = { "biome" },
      markdown = { "rumdl" },
      ["markdown.mdx"] = { "rumdl" },
    },
    formatters = {
      biome = {
        args = { "format", "--format-with-errors=true", "--stdin-file-path", "$FILENAME" },
      },
      shfmt = {
        prepend_args = { "-i", "2" },
      },
      isort = {
        command = function()
          if vim.g.python_host_path then
            local isort_path = vim.g.python_host_path:gsub("python3?$", "isort")
            if vim.fn.executable(isort_path) == 1 then
              return isort_path
            end
          end

          return "isort"
        end,
      },
      rumdl = {
        command = "rumdl",
        args = { "fmt", "--stdin" },
      },
    },
  })
end

return M
