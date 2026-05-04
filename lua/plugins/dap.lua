return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "C:/Users/xtx1212/AppData/Local/nvim-data/codelldb-win32-x64/extension/adapter/codelldb.exe",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.c = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/bin/Debug/Calculator.exe", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
      }
      dap.configurations.cpp = dap.configurations.c

      local function cleanup_dap_residue()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local buf_name = vim.api.nvim_buf_get_name(buf)
          if buf_name:match("%[dap%-terminal%]") or buf_name:match("dap%-repl") then
            pcall(vim.api.nvim_win_close, win, true)
          end
        end
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          local buf_name = vim.api.nvim_buf_get_name(buf)
          if buf_name:match("%[dap%-terminal%]") or buf_name:match("dap%-repl") then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
          end
        end
      end

      dap.listeners.after.event_terminated["cleanup"] = cleanup_dap_residue
      dap.listeners.after.event_exited["cleanup"] = cleanup_dap_residue
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = { automatic_installation = false },
  },
}
