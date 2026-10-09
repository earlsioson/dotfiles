local M = {}

local preview_files = {}

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

  -- :h nvim_get_runtime_file() keeps the template portable across config roots.
  local template = vim.api.nvim_get_runtime_file("templates/markdown_preview.html", false)[1]
  if not template then
    vim.notify("Markdown preview template is missing", vim.log.levels.ERROR)
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
    "--template=" .. template,
    "--toc",
    "--toc-depth=3",
    "--id-prefix=md-",
    "--syntax-highlighting=none",
    "-V",
    "pagetitle=" .. html_escape(title),
  }, { stdin = markdown, text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        vim.notify(("Unable to render markdown preview: %s"):format(result.stderr), vim.log.levels.ERROR)
        return
      end

      local base_uri = vim.uri_from_fname(source_dir .. "/")
      -- A source-directory base resolves images/links, but also resolves #fragments.
      -- Keep contents links and footnote navigation inside the preview itself.
      local preview_uri = vim.uri_from_fname(output_path)
      local html = result.stdout:gsub('href="#([^"]*)"', function(fragment)
        return ('href="%s#%s"'):format(html_escape(preview_uri), fragment)
      end)
      html = html:gsub("</head>", function()
        return ('<base href="%s">\n</head>'):format(html_escape(base_uri))
      end, 1)
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
