return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy", -- 在编辑器空闲时加载，不影响启动速度
    opts = {
      -- 这里的配置是可选的，使用默认配置即可
      plugins = { spelling = true },
      defaults = {}, -- 如果你需要定义默认映射组
      win = {
        border = "rounded", -- 边框样式：single, double, rounded, solid, none
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      
      -- 注册快捷键名称（让提示更可读）
      wk.add({
        --{ "<leader>b", group = "Buffer" },
        --{ "<leader>c", group = "Code" },
        --{ "<leader>f", group = "File/Search" },
        --{ "<leader>g", group = "Git" },
        --{ "<leader>l", group = "LSP" },
        --{ "<leader>s", group = "Split/Window" },
        --{ "<leader>w", group = "Window" },
      })
    end,
  },
}
