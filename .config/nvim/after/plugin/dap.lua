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

for _, ecma_script in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
  dap.configurations[ecma_script] = {
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Launch Chrome against localhost",
      url = "http://localhost:3000",
      webRoot = "${workspaceFolder}",
    },
    {
      type = "pwa-chrome",
      request = "attach",
      name = "Attach to Chrome",
      port = 9222,
      webRoot = "${workspaceFolder}",
    },
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
    }
  }
end
dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = vim.env.HOME .. '/.local/share/nvim/mason/bin/codelldb',
    args = {'--port', '${port}'},
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

vim.keymap.set("n", "<leader>Dc", dap.continue)
vim.keymap.set("n", "<leader>DO", dap.step_over)
vim.keymap.set("n", "<leader>Di", dap.step_into)
vim.keymap.set("n", "<leader>Do", dap.step_out)
vim.keymap.set("n", "<leader>Db", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>DB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
vim.keymap.set("n", "<leader>DL", function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set("n", "<leader>Dr", dap.repl.open)
vim.keymap.set("n", "<leader>Dl", dap.run_last)

dapui.setup()
vim.keymap.set("n", "<leader>du", dapui.toggle)

dap_go.setup()
dap_python.setup('~/.venv/nvim/bin/python')
dap_vscode_js.setup({
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation. 
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
})
