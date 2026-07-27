-- lspconfig ships mojo with `.git` as its only root marker, which resolves the
-- workspace to the repository rather than the project when a repo holds more
-- than one. uv-managed Mojo projects are anchored by pyproject.toml.
local root_markers = { "pyproject.toml", "mojoproject.toml", ".git" }

-- uv installs mojo-lsp-server into the project venv rather than on PATH, and
-- the binary dlopens the Modular C++ libraries that sit beside it under
-- site-packages; without them on the loader path it exits 127 on
-- libMSupportGlobals.so. Both values are per-project, so they are resolved when
-- a client starts rather than when this module loads — `vim.lsp.config` entries
-- are required once per session and cached, so anything computed at module
-- scope freezes to whichever buffer happened to load es.plugins.lsp first.

--- @param root string
--- @return string? executable Project-local server, else a PATH one, else nil.
local function resolve_server(root)
  local venv_exec = vim.fs.joinpath(root, ".venv", "bin", "mojo-lsp-server")
  if vim.fn.executable(venv_exec) == 1 then
    return venv_exec
  end
  if vim.fn.executable("mojo-lsp-server") == 1 then
    return "mojo-lsp-server"
  end
end

--- @param root string
--- @return table<string, string>? env
local function resolve_env(root)
  local lib_dirs = vim.fn.glob(
    vim.fs.joinpath(root, ".venv", "lib", "python*", "site-packages", "modular", "lib"),
    -- nosuf: keep 'wildignore' and 'suffixes' from filtering the matches.
    true,
    true
  )
  if #lib_dirs == 0 or vim.fn.isdirectory(lib_dirs[1]) ~= 1 then
    return nil
  end

  -- glibc's loader only. macOS resolves these through the dylib install names,
  -- so the variable is inert there and the Linux path stays the only one.
  local existing = vim.env.LD_LIBRARY_PATH
  return {
    LD_LIBRARY_PATH = (existing and existing ~= "") and (lib_dirs[1] .. ":" .. existing)
      or lib_dirs[1],
  }
end

return {
  root_markers = root_markers,

  -- Activation gate: leaving on_dir uncalled keeps LSP off for the buffer, so a
  -- Mojo file outside any project with a server never attempts a spawn. This is
  -- what lets es.plugins.lsp enable mojo without probing PATH at startup.
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
    if resolve_server(root) then
      on_dir(root)
    end
  end,

  -- `cmd` as a function is the documented hook for a per-project executable
  -- (:h vim.lsp.ClientConfig). It runs once per client with config.root_dir
  -- already resolved, so two Mojo projects open at once each get their own venv.
  cmd = function(dispatchers, config)
    local root = config.root_dir or vim.fn.getcwd()
    local exec = resolve_server(root) or "mojo-lsp-server"
    return vim.lsp.rpc.start({ exec }, dispatchers, {
      cwd = config.cmd_cwd,
      env = resolve_env(root),
    })
  end,
}
