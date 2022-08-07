if not pcall(require, "dapui") then
  return
end
if not pcall(require, "dap-go") then
  return
end
if not pcall(require, "dap-python") then
  return
end
if not pcall(require, "dap-vscode-js") then
  return
end
if not pcall(require, "dap") then
  return
end

require('dapui').setup()
require('dap-go').setup()
require('dap-python').setup('~/.venv/nvim/bin/python')
require("dap-vscode-js").setup({
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation. 
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
})

for _, language in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
  require("dap").configurations[language] = {
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
      processId = require'dap.utils'.pick_process,
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
require('dap').set_log_level('DEBUG')

vim.keymap.set("n", "<leader>dc", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<leader>dv", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<leader>di", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<leader>do", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
vim.keymap.set("n", "<leader>dl", ":lua require'dap'.run_last()<CR>")
vim.keymap.set("n", "<leader>du", ":lua require'dapui'.toggle()<CR>")

