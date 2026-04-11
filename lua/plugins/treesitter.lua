return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "master",
    build = ":TSUpdate",
    config = function()
      -- 防止模块缺失时直接炸掉
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify("nvim-treesitter.configs not found", vim.log.levels.ERROR)
        return
      end

      configs.setup({
        ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
