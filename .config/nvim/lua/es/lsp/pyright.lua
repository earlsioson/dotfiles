local function project_python(root_dir)
  if not root_dir then
    return nil
  end

  local candidates = {
    vim.fs.joinpath(root_dir, ".venv", "bin", "python"),
    vim.fs.joinpath(root_dir, ".venv", "Scripts", "python.exe"),
  }

  for _, candidate in ipairs(candidates) do
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end
end

return {
  before_init = function(_, config)
    local python_path = project_python(config.root_dir)
    if not python_path then
      return
    end

    config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
      python = {
        pythonPath = python_path,
      },
    })
  end,
}
