local M = {}

local function project_python()
  local root = vim.fs.root(0, { "pyproject.toml", ".git" })
  if not root then
    return nil
  end

  for _, relative_path in ipairs({ ".venv/bin/python", ".venv/Scripts/python.exe" }) do
    local path = vim.fs.joinpath(root, relative_path)
    if vim.fn.executable(path) == 1 then
      return vim.uv.fs_realpath(path) or path
    end
  end
end

local function project_kernel()
  local python_path = project_python()
  if not python_path then
    return nil
  end

  local result = vim.system({
    vim.g.python_host_path,
    "-m",
    "jupyter_client.kernelspecapp",
    "list",
    "--json",
  }, { text = true }):wait()

  if result.code ~= 0 then
    return nil
  end

  local ok, decoded = pcall(vim.json.decode, result.stdout)
  if not ok then
    return nil
  end

  for name, kernel in pairs(decoded.kernelspecs or {}) do
    local argv = kernel.spec and kernel.spec.argv
    local kernel_python = argv and argv[1]
    if kernel_python and vim.uv.fs_realpath(kernel_python) == python_path then
      return name
    end
  end
end

local function ensure_server()
  if vim.v.servername == nil or vim.v.servername == "" then
    local ok = pcall(vim.fn.serverstart)
    if not ok or vim.v.servername == "" then
      local tmpdir = (vim.uv and vim.uv.os_tmpdir()) or "/tmp"
      local sock = vim.fs.joinpath(tmpdir, string.format("nvim_%d.sock", vim.fn.getpid()))
      pcall(vim.fn.serverstart, sock)
    end
  end
end

function M.setup()
  local pyrepl = require("pyrepl").setup({
    python_path = vim.g.python_host_path,
  })

  vim.api.nvim_del_user_command("PyreplOpen")
  vim.api.nvim_create_user_command("PyreplOpen", function(opts)
    ensure_server()

    if opts.bang then
      pyrepl.open_repl()
      return
    end

    if #opts.fargs > 0 then
      pyrepl.open_repl(opts.fargs)
      return
    end

    local kernel = project_kernel()
    if kernel then
      pyrepl.open_repl({ "--kernel", kernel })
    else
      pyrepl.open_repl()
    end
  end, {
    nargs = "*",
    bang = true,
    complete = require("pyrepl.python").get_console_completions,
  })
end

return M
