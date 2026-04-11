return {
  "akinsho/toggleterm.nvim",
  version = "*", -- 使用稳定版本
  config = function()
    local toggleterm = require("toggleterm")

    -- 1. 基础设置
    toggleterm.setup({
      size = 20, -- 终端窗口的大小 (行数或列数)
      open_mapping = [[<c-`>]], -- 全局快捷键：Ctrl + `
      hide_numbers = true, -- 隐藏终端缓冲区的行号
      shade_filetypes = {}, -- 不遮挡文件类型颜色
      shade_terminals = true, -- 给终端背景加一点阴影
      shading_factor = 2, -- 阴影深浅
      start_in_insert = true, -- 打开终端时自动进入插入模式
      insert_mappings = true, -- 在插入模式下也能使用映射
      persist_size = true, -- 记住窗口大小
      direction = "float", -- 默认布局：float(浮动) | horizontal(水平) | vertical(垂直) | tab
      close_on_exit = true, -- 终端进程退出时自动关闭窗口
      auto_scroll = true, -- 自动滚动到底部
      float_opts = {
        border = "curved", -- 浮动窗口边框样式: single, double, rounded, solid, shadow, curved
        winblend = 0, -- 透明度 (0-100)
      },
    })

    -- 2. 设置终端模式下的快捷键
    -- 作用域设置为 't' 表示仅在终端模式下生效
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 } -- buffer=0 表示当前缓冲区
      -- 按 Esc 退出终端模式回到普通模式
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
      -- 按 Ctrl+h/j/k/l 切换窗口焦点
      vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    end

    -- 当打开终端时自动应用上面的快捷键
    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
}
