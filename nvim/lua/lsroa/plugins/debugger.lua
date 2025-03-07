return {
  {
    "nvim-telescope/telescope-dap.nvim",
    require = { "nvim-telescope/telescope.nvim" },
    config = function()
      require('telescope').load_extension('dap')
    end
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require('dap')

      vim.keymap.set("n", "<Leader>db",
        function()
          dap.toggle_breakpoint()
        end,
        { noremap = true })

      vim.keymap.set("n", "<Leader>dc",
        function()
          dap.continue()
        end,
        { noremap = true })

      vim.keymap.set("n", "<Leader>dr",
        function()
          dap.repl.open()
        end,
        { noremap = true })

      vim.keymap.set("n", "]d",
        function()
          dap.step_over()
        end,
        { noremap = true })

      vim.keymap.set("n", "[d",
        function()
          dap.step_into()
        end,
        { noremap = true })

      vim.keymap.set("n", "<Leader>dk",
        function()
          require("dap.ui.widgets").hover()
        end,
        { noremap = true })


      dap.adapters.godot = {
        type = "server",
        host = '127.0.0.1',
        port = 6006,
      }

      dap.configurations.gdscript = {
        {
          type = "godot",
          request = "launch",
          name = "Launch scene",
          project = "${workspaceFolder}",
          launch_scene = true,
        }
      }

      dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = os.getenv('HOME') ..
            '/Developer/cpptools/cpptools-macOS-arm64/extension/debugAdapters/bin/OpenDebugAD7',
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "cppdbg",
          request = "launch",
          MIMode = 'lldb',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopAtEntry = true,
        },
        {
          name = 'Attach to gdbserver :1234',
          type = 'cppdbg',
          request = 'launch',
          MIMode = 'gdb',
          miDebuggerServerAddress = 'localhost:1234',
          miDebuggerPath = '/usr/bin/gdb',
          cwd = '${workspaceFolder}',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
        }, }
    end
  },
  {
    'mfussenegger/nvim-dap-python',
    ft = "python",
    requires = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      require('dap-python').setup()

      local pythonAttachConfig = {
        type = "python",
        request = "attach",
        connect = {
          port = 5678,
          host = "0.0.0.0",
        },
        mode = "remote",
        name = "Container Attach (with choose remote dir)",
        cwd = vim.fn.getcwd(),
        pathMappings = {
          {
            localRoot = vim.fn.getcwd(),
            remoteRoot = "/app",
          },
        },
      }
      table.insert(require("dap").configurations.python, pythonAttachConfig)
      local signs = {
        { text = "DapBreakpoint", icon = "💔" },
        { text = "DapStopped", icon = '👉' },
      }

      for _, sign in pairs(signs) do
        vim.fn.sign_define(sign.text, {
          text = sign.icon,
          texthl = sign.text,
          linehl = "",
          numhl = ""
        })
      end
    end
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    requires = {
      "mfussenegger/nvim-dap",
    },
    ft = "typescript",
    config = function()
      require("dap-vscode-js").setup {
        node_path = "node",
        debugger_path = os.getenv("HOME") .. "/Developer/vscode-js-debug",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
      }

      local dap = require("dap")

      if vim.fn.winwidth(0) > 150 then
        dap.defaults.fallback.terminal_win_cmd = 'split new'
      else
        dap.defaults.fallback.terminal_win_cmd = 'vsplit new'
      end

      dap.configurations.typescript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Start server",
          protocol = "inspector",
          cwd = vim.fn.getcwd(),
          runtimeExecutable = "yarn",
          runtimeArgs = {
            "start:debug"
          },
          console = "integratedTerminal",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Jest (Integration) Tests",
          trace = true,
          runtimeExecutable = "node",
          runtimeArgs = {
            "./node_modules/jest/bin/jest.js",
            "--config",
            "${workspaceFolder}/jest.integration.config.js",
            "--runInBand",
            "${file}"
          },
          rootPath = "${workspaceFolder}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Jest (Unit) Tests",
          trace = true,
          runtimeExecutable = "node",
          runtimeArgs = {
            "./node_modules/jest/bin/jest.js",
            "--config",
            "${workspaceFolder}/jest.unitTest.config.js",
            "--runInBand",
            "${file}"
          },
          rootPath = "${workspaceFolder}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
        },
      }
    end
  },
  {
    "leoluz/nvim-dap-go",
    requires = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dap_go = require('dap-go')
      dap_go.setup()
      vim.keymap.set("n", "<Leader>dt",
        function()
          dap_go.debug_test()
        end,
        { noremap = true })
    end,
    ft = "go",
  },
}
