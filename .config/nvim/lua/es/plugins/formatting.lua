return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    opts = {
      -- Define your formatters
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
      -- Set up format-on-save
      -- format_on_save = { timeout_ms = 500, lsp_fallback = true },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        isort = {
          command = function()
            -- Try to derive isort path from the configured python_host_path
            if vim.g.python_host_path then
              -- Replace 'python' (or 'python3') at the end of the path with 'isort'
              local isort_path = vim.g.python_host_path:gsub("python3?$", "isort")
              if vim.fn.executable(isort_path) == 1 then
                return isort_path
              end
            end

            -- Fallback to system isort
            return "isort"
          end,
        },
        rumdl = {
          command = "rumdl",
          args = { "fmt", "--stdin" },
        },
      },
    },
    init = function()
      -- If you want the 'conform' command available globally
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
