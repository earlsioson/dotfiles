local has_dap, dap = pcall(require, "dap")
if not has_dap then
  return
end

local has_dap_utils, dap_utils = pcall(require, "dap.utils")
if not has_dap_utils then
  return
end

local has_dap_ui_widgets, dap_ui_widgets = pcall(require, "dap.ui.widgets")
if not has_dap_ui_widgets then
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

local has_ext_vscode, ext_vscode = pcall(require, "dap.ext.vscode")
if not has_ext_vscode then
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

dap.set_log_level('DEBUG')

vim.keymap.set("n", "<Leader>bv",
  function() ext_vscode.load_launchjs(nil, { codelldb = { 'c', 'cpp', 'rust', 'zig' } }) end)
vim.keymap.set("n", "<Leader>bc", dap.continue)
vim.keymap.set("n", "<Leader>bo", dap.step_over)
vim.keymap.set("n", "<Leader>bI", dap.step_into)
vim.keymap.set("n", "<Leader>bO", dap.step_out)
vim.keymap.set("n", "<Leader>bb", dap.toggle_breakpoint)
vim.keymap.set("n", "<Leader><Leader>bb", dap.clear_breakpoints)
vim.keymap.set("n", "<Leader>be", function() dap.set_exception_breakpoints() end)
vim.keymap.set("n", "<Leader>bB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
vim.keymap.set("n", "<Leader>bL",
  function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set("n", "<Leader>br", dap.repl.open)
vim.keymap.set("n", "<Leader>bl", dap.run_last)
vim.keymap.set({ 'n', 'v' }, '<Leader>bh', function()
  dap_ui_widgets.hover()
end)
vim.keymap.set({ 'n', 'v' }, '<Leader>bp', function()
  dap_ui_widgets.preview()
end)
vim.keymap.set('n', '<Leader>bf', function()
  dap_ui_widgets.centered_float(dap_ui_widgets.frames)
end)
vim.keymap.set('n', '<Leader>bs', function()
  dap_ui_widgets.centered_float(dap_ui_widgets.scopes)
end)

dapui.setup()
vim.keymap.set("n", "<Leader>bu", dapui.toggle)

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
