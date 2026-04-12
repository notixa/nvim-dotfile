return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    local toggleterm = require("toggleterm")

    -- 1. 基础设置：禁用 open_mapping（我们自己控制）
    toggleterm.setup({
      size = 20,
      open_mapping = nil, -- 👈 关键：设为 nil，不再自动绑定
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float", -- 默认方向（但会被实例覆盖）
      close_on_exit = true,
      auto_scroll = true,
      float_opts = {
        border = "curved",
        winblend = 0,
      },
    })

    -- 2. 创建两个独立终端实例

    -- 浮动终端
    local Terminal = require("toggleterm.terminal").Terminal
    local float_terminal = Terminal:new({
      direction = "float",
      close_on_exit = true,
      on_open = function()
        vim.cmd("startinsert!")
      end,
    })

    -- 右侧终端
    local right_terminal = Terminal:new({
      direction = "vertical",
      close_on_exit = true,
      on_open = function()
        vim.cmd("startinsert!")
      end,
    })

    -- 3. 绑定快捷键

    -- <C-`> → 切换浮动终端
    vim.keymap.set("n", "<C-`>", function()
      float_terminal:toggle()
    end, { desc = "Toggle Float Terminal" })

    -- <leader>tt → 切换右侧终端
    vim.keymap.set("n", "<leader>tt", function()
      right_terminal:toggle()
    end, { desc = "Toggle Right Terminal" })

    -- 4. 终端模式快捷键
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    end

    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
}
