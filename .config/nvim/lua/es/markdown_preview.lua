local M = {}

local preview_files = {}

local stylesheet = [[
  :root {
    color-scheme: light dark;
    --bg: #ffffff;
    --fg: #1f2328;
    --muted: #656d76;
    --accent: #0969da;
    --border: #d0d7de;
    --code-bg: #f6f8fa;
  }

  @media (prefers-color-scheme: dark) {
    :root {
      --bg: #0d1117;
      --fg: #e6edf3;
      --muted: #8d96a0;
      --accent: #4493f8;
      --border: #30363d;
      --code-bg: #161b22;
    }
  }

  *, *::before, *::after {
    box-sizing: border-box;
  }

  body {
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    font-size: 16px;
    line-height: 1.6;
    color: var(--fg);
    background-color: var(--bg);
    max-width: 860px;
    margin: 0 auto;
    padding: 2rem 1.5rem;
    overflow-wrap: break-word;
  }

  h1, h2, h3, h4, h5, h6 {
    line-height: 1.25;
    margin-top: 1.5em;
    margin-bottom: 0.5em;
    font-weight: 600;
  }

  h1 {
    font-size: 2em;
    padding-bottom: 0.3em;
    border-bottom: 1px solid var(--border);
  }

  h2 {
    font-size: 1.5em;
    padding-bottom: 0.3em;
    border-bottom: 1px solid var(--border);
  }

  h3 { font-size: 1.25em; }
  h4 { font-size: 1em; }

  p, ul, ol, blockquote, table, pre {
    margin-top: 0;
    margin-bottom: 1rem;
  }

  a {
    color: var(--accent);
    text-decoration: none;
  }
  a:hover {
    text-decoration: underline;
  }

  code, pre {
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
    font-size: 0.875em;
  }

  code {
    padding: 0.2em 0.4em;
    background-color: var(--code-bg);
    border-radius: 6px;
  }

  pre {
    padding: 1rem;
    overflow: auto;
    background-color: var(--code-bg);
    border-radius: 6px;
    line-height: 1.45;
  }

  pre code {
    padding: 0;
    background-color: transparent;
    border-radius: 0;
  }

  blockquote {
    margin-left: 0;
    padding-left: 1rem;
    color: var(--muted);
    border-left: 4px solid var(--border);
  }

  table {
    width: 100%;
    border-collapse: collapse;
  }

  th, td {
    padding: 0.5rem 0.75rem;
    border: 1px solid var(--border);
  }

  th {
    background-color: var(--code-bg);
    font-weight: 600;
  }

  img {
    max-width: 100%;
    height: auto;
  }

  hr {
    height: 1px;
    padding: 0;
    margin: 2rem 0;
    background-color: var(--border);
    border: 0;
  }
]]

local function html_escape(value)
  return value
    :gsub("&", "&amp;")
    :gsub('"', "&quot;")
    :gsub("<", "&lt;")
    :gsub(">", "&gt;")
end

local function cleanup()
  for _, path in pairs(preview_files) do
    pcall(vim.uv.fs_unlink, path)
  end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("es_markdown_preview", { clear = true }),
  callback = cleanup,
})

function M.open()
  if vim.fn.executable("pandoc") ~= 1 then
    vim.notify("pandoc is not installed or is not on PATH", vim.log.levels.ERROR)
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local source_path = vim.api.nvim_buf_get_name(buf)
  local source_dir = source_path ~= "" and vim.fn.fnamemodify(source_path, ":p:h") or vim.uv.cwd()
  local title = source_path ~= "" and vim.fn.fnamemodify(source_path, ":t") or "Markdown Preview"
  local markdown = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
  local output_path = preview_files[buf] or (vim.fn.tempname() .. ".html")
  preview_files[buf] = output_path

  vim.system({
    "pandoc",
    "--from=gfm",
    "--to=html5",
    "--standalone",
    "-V",
    "pagetitle=" .. title,
  }, { stdin = markdown, text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        vim.notify(("Unable to render markdown preview: %s"):format(result.stderr), vim.log.levels.ERROR)
        return
      end

      local base_uri = vim.uri_from_fname(source_dir .. "/")
      local unstyled_html = result.stdout:gsub("<style>.-</style>", "")
      local additions = ("<base href=\"%s\">\n<style>%s</style>\n</head>"):format(html_escape(base_uri), stylesheet)
      local html = unstyled_html:gsub("</head>", additions, 1)
      local ok, err = pcall(vim.fn.writefile, vim.split(html, "\n", { plain = true }), output_path)
      if not ok then
        vim.notify(("Unable to write markdown preview: %s"):format(err), vim.log.levels.ERROR)
        return
      end

      vim.ui.open(vim.uri_from_fname(output_path))
    end)
  end)
end

return M
