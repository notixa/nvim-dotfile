return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall", "TSUninstall" },
  keys = {
    { "<C-space>", desc = "Increment Selection", mode = { "n", "x" } },
    { "<BS>", desc = "Decrement Selection", mode = "x" },
  },
  opts = {
    ensure_installed = {
      "lua", "vim", "vimdoc", "query",
      "javascript", "typescript", "tsx",
      "python", "html", "css",
      "markdown", "markdown_inline",
      "bash", "gitignore", "json", "yaml",
    },

    -- 新语言自动安装（首次打开对应文件时）
    auto_install = true,

    highlight = {
      enable = true,
      -- 某些语言仍用传统 regex 高亮（可选）
      additional_vim_regex_highlighting = false,
      disable = function(_, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
        return false
      end,
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<BS>",
      },
    },

    indent = {
      enable = true,
      -- python 有时会和 treesitter 缩进冲突，可按需打开：
      -- disable = { "python" },
    },
  },

  config = function(_, opts)
    require("nvim-treesitter.config").setup(opts)
  end,
}
