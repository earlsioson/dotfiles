return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = {
          "codelldb",
          "debugpy",
          "delve",
          "js-debug-adapter",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require("dap")
      local dap_utils = require("dap.utils")
      local widgets = require("dap.ui.widgets")
      local dapui = require("dapui")
      local dap_go = require("dap-go")
      local dap_python = require("dap-python")
      local ext_vscode = require("dap.ext.vscode")

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "js-debug-adapter",
          args = { "${port}" },
        },
      }

      for _, ecma in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
        dap.configurations[ecma] = {
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
            name = 'Start Chrome with "localhost"',
            url = "http://localhost:3333",
            webRoot = "${workspaceFolder}",
            userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
          },
          {
            name = "Next.js: node-terminal",
            type = "pwa-node",
            request = "launch",
            program = "${workspaceFolder}/node_modules/.bin/next dev",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
          },
        }
      end

      dap.adapters.codelldb = {
        type = "executable",
        command = vim.env.HOME .. "/.local/share/nvim/mason/bin/codelldb",
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp
      dap.configurations.zig = dap.configurations.cpp

      dap.set_log_level("DEBUG")

      dapui.setup()
      dap_go.setup()
      dap_python.setup("~/dev/repos/dotfiles/.venv/bin/python")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
    keys = {
      {
        "<Leader>bv",
        function()
          require("dap.ext.vscode").load_launchjs(nil, { lldb = { "c", "cpp", "rust", "zig" } })
        end,
        desc = "DAP load launch.json",
      },
      {
        "<Leader>bc",
        function()
          require("dap").continue()
        end,
        desc = "DAP continue",
      },
      {
        "<Leader>bo",
        function()
          require("dap").step_over()
        end,
        desc = "DAP step over",
      },
      {
        "<Leader>bI",
        function()
          require("dap").step_into()
        end,
        desc = "DAP step into",
      },
      {
        "<Leader>bO",
        function()
          require("dap").step_out()
        end,
        desc = "DAP step out",
      },
      {
        "<Leader>bb",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP breakpoint",
      },
      {
        "<Leader>bt",
        function()
          require("dap").terminate()
        end,
        desc = "DAP terminate",
      },
      {
        "<Leader><Leader>bb",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "DAP clear breakpoints",
      },
      {
        "<Leader>be",
        function()
          require("dap").set_exception_breakpoints()
        end,
        desc = "DAP exception breakpoints",
      },
      {
        "<Leader>bB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "DAP conditional breakpoint",
      },
      {
        "<Leader>bL",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end,
        desc = "DAP logpoint",
      },
      {
        "<Leader>br",
        function()
          require("dap").repl.open()
        end,
        desc = "DAP REPL",
      },
      {
        "<Leader>bl",
        function()
          require("dap").run_last()
        end,
        desc = "DAP run last",
      },
      {
        "<Leader>bw",
        function()
          require("dapui").float_element("watches")
        end,
        mode = { "n", "v" },
        desc = "DAP watches",
      },
      {
        "<Leader>bh",
        function()
          require("dap.ui.widgets").hover()
        end,
        mode = { "n", "v" },
        desc = "DAP hover",
      },
      {
        "<Leader>bp",
        function()
          require("dap.ui.widgets").preview()
        end,
        mode = { "n", "v" },
        desc = "DAP preview",
      },
      {
        "<Leader>bf",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.frames)
        end,
        desc = "DAP frames",
      },
      {
        "<Leader>bs",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end,
        desc = "DAP scopes",
      },
      {
        "<Leader>bu",
        function()
          require("dapui").toggle()
        end,
        desc = "DAP UI toggle",
      },
    },
  },
}
