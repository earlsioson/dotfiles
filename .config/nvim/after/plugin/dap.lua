local has_dap, dap = pcall(require, "dap")
if not has_dap then
  return
end

local has_dap_utils, dap_utils = pcall(require, "dap.utils")
if not has_dap_utils then
  return
end

local has_dapui, dapui = pcall(require, "dapui")
if not has_dapui then
  return
end

local has_dap_go, dap_go = pcall(require, "dap-go")
if not has_dap_go then
  return
end

local has_dap_python, dap_python = pcall(require, "dap-python")
if not has_dap_python then
  return
end

local has_dap_vscode_js, dap_vscode_js = pcall(require, "dap-vscode-js")
if not has_dap_vscode_js then
  return
end

local has_dap_utils, dap_utils = pcall(require, "dap.utils")
if not has_dap_utils then
  return
end
for _, ecma_script in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
  dap.configurations[ecma_script] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = dap_utils.pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest Tests",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "./node_modules/jest/bin/jest.js",
        "--runInBand",
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    },
  }
end
dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = vim.env.HOME .. '/.local/share/nvim/mason/bin/codelldb',
    args = { '--port', '${port}' },
  }
}
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

dap.set_log_level('DEBUG')

vim.keymap.set("n", "<Leader><Leader>dc", dap.continue)
vim.keymap.set("n", "<Leader><Leader>dO", dap.step_over)
vim.keymap.set("n", "<Leader><Leader>di", dap.step_into)
vim.keymap.set("n", "<Leader><Leader>do", dap.step_out)
vim.keymap.set("n", "<Leader><Leader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<Leader><Leader>dB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
vim.keymap.set("n", "<Leader><Leader>dL",
  function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set("n", "<Leader><Leader>dr", dap.repl.open)
vim.keymap.set("n", "<Leader><Leader>dl", dap.run_last)
vim.keymap.set({ 'n', 'v' }, '<Leader><Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({ 'n', 'v' }, '<Leader><Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader><Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader><Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)

dapui.setup()
vim.keymap.set("n", "<Leader><Leader>du", dapui.toggle)

dap_go.setup()
dap_python.setup('~/.venv/nvim/bin/python')
dap_vscode_js.setup({
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  debugger_path = vim.env.HOME .. '/.local/share/nvim/lazy/vscode-js-debug',                   -- Path to vscode-js-debug installation.
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})
