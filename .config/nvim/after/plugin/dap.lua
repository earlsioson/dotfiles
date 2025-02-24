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

local has_ext_vscode, ext_vscode = pcall(require, "dap.ext.vscode")
if not has_ext_vscode then
  return
end

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    -- 💀 Make sure to update this path to point to your installation
    args = { "vim.env.HOME .. '/.local/share/oss/vscode-js-debug/src/dapDebugServer.ts',", "${port}" },
  }
}

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
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Start Chrome with \"localhost\"",
      url = "http://localhost:3333",
      webRoot = "${workspaceFolder}",
      userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
    },
  }
end

dap.adapters.codelldb = {
  type = 'executable',
  command = vim.env.HOME .. '/.local/share/nvim/mason/bin/codelldb',
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
    stopOnEntry = false,
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
dap.configurations.zig = dap.configurations.cpp

dap.set_log_level('DEBUG')

vim.keymap.set("n", "<Leader>bv",
  function() ext_vscode.load_launchjs(nil, { lldb = { 'c', 'cpp', 'rust', 'zig' } }) end)
vim.keymap.set("n", "<Leader>bc", dap.continue)
vim.keymap.set("n", "<Leader>bo", dap.step_over)
vim.keymap.set("n", "<Leader>bI", dap.step_into)
vim.keymap.set("n", "<Leader>bO", dap.step_out)
vim.keymap.set("n", "<Leader>bb", dap.toggle_breakpoint)
vim.keymap.set("n", "<Leader>bt", dap.terminate)
vim.keymap.set("n", "<Leader><Leader>bb", dap.clear_breakpoints)
vim.keymap.set("n", "<Leader>be", function() dap.set_exception_breakpoints() end)
vim.keymap.set("n", "<Leader>bB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
vim.keymap.set("n", "<Leader>bL",
  function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set("n", "<Leader>br", dap.repl.open)
vim.keymap.set("n", "<Leader>bl", dap.run_last)
vim.keymap.set({ 'n', 'v' }, '<Leader>bw', function()
  dapui.float_element('watches')
end)
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
