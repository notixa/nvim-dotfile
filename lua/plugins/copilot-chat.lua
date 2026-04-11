return {
  -- 1. CopilotChat 插件配置
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary", -- 使用 canary 分支以获取最新功能（可选，稳定版可去掉此行）
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- Copilot 核心库
      { "nvim-lua/plenary.nvim" }, -- 依赖库
    },
    build = "make tiktoken", -- 仅针对 Linux/macOS，用于支持本地 tokenizer
    opts = {
      -- 这里可以配置 CopilotChat 的行为
      -- 例如：窗口布局、模型选择等
      window = {
        layout = "float", -- 悬浮窗模式
        width = 0.8,
        height = 0.8,
      },
      -- 默认提示词
      prompts = {
        Explain = {
          prompt = "##selection\n\nExplain the code above in simple terms.",
        },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      chat.setup(opts)
    end,
    -- 2. 快捷键映射 (推荐放在这里)
    keys = {
      -- 打开 Copilot Chat 悬浮窗
      { "<leader>a", "<cmd>CopilotChat<cr>", desc = "Copilot Chat" },
      -- 打开 Copilot Chat 右侧面板
      { "<leader>ap", "<cmd>CopilotChatPanel<cr>", desc = "Copilot Panel" },
      
      -- 视觉模式下：解释选中代码
      {
        "<leader>ae",
        "<cmd>CopilotChatExplain<cr>",
        mode = "v",
        desc = "Explain Code",
      },
      -- 视觉模式下：修复选中代码
      {
        "<leader>ar",
        "<cmd>CopilotChatFixDiagnostic<cr>",
        mode = "v",
        desc = "Fix Code",
      },
      -- 视觉模式下：添加注释
      {
        "<leader>ad",
        "<cmd>CopilotChatDocs<cr>",
        mode = "v",
        desc = "Add Docs",
      },
    },
  },

  -- 3. Copilot 核心配置 (代码补全)
  -- 注意：CopilotChat 依赖 copilot.lua 进行认证
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth", -- 安装时自动触发认证（如果未认证）
    opts = {
      suggestion = {
        enabled = false, -- 启用代码建议
        auto_trigger = false, -- 自动触发
        hide_during_completion = true, -- 补全时隐藏建议
      },
      panel = {
        enabled = true,
      },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
    end,
  },
}
