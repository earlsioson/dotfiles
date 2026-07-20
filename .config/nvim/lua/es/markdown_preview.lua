local M = {}

local preview_files = {}

local stylesheet = [[
  :root {
    color-scheme: light dark;
    --canvas: #ffffff;
    --foreground: #1f2328;
    --muted: #59636e;
    --accent: #0969da;
    --border: #d1d9e0;
    --surface: #f6f8fa;
  }
  @media (prefers-color-scheme: dark) {
    :root {
      --canvas: #0d1117;
      --foreground: #f0f6fc;
      --muted: #9198a1;
      --accent: #4493f8;
      --border: #3d444d;
      --surface: #151b23;
    }
  }
  @supports (color: light-dark(white, black)) {
    :root {
      --canvas: light-dark(#ffffff, #0d1117);
      --foreground: light-dark(#1f2328, #f0f6fc);
      --muted: light-dark(#59636e, #9198a1);
      --accent: light-dark(#0969da, #4493f8);
      --border: light-dark(#d1d9e0, #3d444d);
      --surface: light-dark(#f6f8fa, #151b23);
    }
  }
  @media print {
    :root {
      --canvas: #ffffff;
      --foreground: #1f2328;
      --muted: #59636e;
      --accent: #0969da;
      --border: #d1d9e0;
      --surface: #f6f8fa;
    }
  }
  *, *::before, *::after { box-sizing: border-box; }
  html { background: var(--canvas); }
  body {
    min-height: 100vh;
    max-width: 980px;
    margin: 0 auto;
    padding: 45px;
    font: 16px/1.5 -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    color: var(--foreground);
    background: var(--canvas);
    overflow-wrap: break-word;
  }
  h1, h2 { padding-block-end: .3em; border-block-end: 1px solid var(--border); }
  a { color: var(--accent); }
  pre, code { font-family: ui-monospace, SFMono-Regular, Consolas, monospace; }
  code { padding: .2em .4em; border-radius: 6px; background: var(--surface); }
  pre { overflow: auto; padding: 16px; border-radius: 6px; background: var(--surface); }
  pre code { padding: 0; background: transparent; }
  blockquote {
    margin-inline-start: 0;
    padding-inline-start: 1em;
    border-inline-start: .25em solid var(--border);
    color: var(--muted);
  }
  table { border-collapse: collapse; }
  th, td { padding: 6px 13px; border: 1px solid var(--border); }
  img { max-width: 100%; }
  @supports (min-height: 100dvh) { body { min-height: 100dvh; } }
  @supports (text-wrap: pretty) { p, li { text-wrap: pretty; } }
  @media (max-width: 767px) { body { padding: 15px; } }
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
    "--metadata",
    "title=" .. title,
  }, { stdin = markdown, text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        vim.notify(("Unable to render markdown preview: %s"):format(result.stderr), vim.log.levels.ERROR)
        return
      end

      local base_uri = vim.uri_from_fname(source_dir .. "/")
      local additions = ("<base href=\"%s\">\n<style>%s</style>\n</head>"):format(html_escape(base_uri), stylesheet)
      local html = result.stdout:gsub("</head>", additions, 1)
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
