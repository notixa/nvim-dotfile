return {
  {
    "nvim-neotest/nvim-nio",
  },
  -- 1. 核心调试插件
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- 2. 可视化界面
      "rcarriga/nvim-dap-ui",
      -- 3. 行尾变量显示
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- --- 初始化 UI ---
      dapui.setup()

      -- --- 配置 C++ 适配器 (使用 lldb) ---
      -- Arch Linux 下 lldb-vscode 通常在 /usr/bin/lldb-vscode
      -- 如果找不到，可以尝试 /usr/bin/lldb-server 或自行编译 llvm 获取
      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode', 
        name = "lldb",
      }

      -- --- 配置 C++ 启动项 ---
      dap.configurations.cpp = {
        {
          name = "Launch file (C++)",
          type = "lldb",
          request = "launch",
          -- 这里配置编译命令，按 F5 时会自动先编译
          -- 假设你使用 clang++，如果是 gcc 请改为 g++
          program = function()
            -- 简单方案：直接询问可执行文件路径
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/a.out", "file")
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          -- 如果需要传参，可以在这里加
          -- env = { { name = "MY_VAR", value = "123" } },
        },
      }

      -- --- 快捷键映射 ---
      vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = "Debug: Start/Continue" })
      vim.keymap.set('n', '<F9>', function() dap.toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = "Debug: Step Over" })
      vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = "Debug: Step Into" })
      vim.keymap.set('n', '<F12>', function() dap.step_out() end, { desc = "Debug: Step Out" })
      vim.keymap.set('n', '<Leader>dr', function() dap.restart() end, { desc = "Debug: Restart" })
      vim.keymap.set('n', '<Leader>dt', function() dap.terminate() end, { desc = "Debug: Terminate" })

      -- --- 自动打开/关闭 UI ---
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
  },
}
