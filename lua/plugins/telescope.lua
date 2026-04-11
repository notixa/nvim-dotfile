return {
  -- 1. 核心依赖 plenary
  { "nvim-lua/plenary.nvim", lazy = true },

  -- 2. 性能扩展：原生 FZF 支持 (需要编译)
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    enabled = true,
    lazy = true,
  },

  -- 3. Telescope 主插件配置
  {
    "nvim-telescope/telescope.nvim",
    -- tag = "0.1.8",
    branch = "master",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      -- 基础快捷键映射
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "查找文件" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "搜索内容" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "缓冲区" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "帮助文档" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "最近文件" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "命令" },
      
      -- Git 相关
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git 状态" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git 分支" },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      
      -- 加载 FZF 扩展 (如果已安装)
      local has_fzf, _ = pcall(require, "telescope._fzf")
      if has_fzf then
        telescope.load_extension("fzf")
      end

      -- 基础配置
      telescope.setup({
        defaults = {
          -- 窗口布局配置
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
          },
          sorting_strategy = "ascending",
          winblend = 0,
          
          -- 映射配置 - 使用字符串引用动作，避免直接使用actions变量
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
              ["<Esc>"] = "close",
              ["<C-c>"] = "close",
            },
            n = {
              ["q"] = "close",
            },
          },
          
          -- Treesitter 预览配置
          preview = {
            treesitter = {
              enable = true,
              disable = {},
              on_init = function()
                if not vim.treesitter then return end

                -- 修复 ft_to_lang 缺失
                local putils = require('telescope.previewers.utils')
                if not putils.ft_to_lang then
                  putils.ft_to_lang = function(ft)
                    return ft
                  end
                end

                -- JSON 特殊处理
                local original_get_lang = vim.treesitter.language.get_lang
                if original_get_lang then
                  vim.treesitter.language.get_lang = function(ft)
                    if ft == "json" then
                      return nil
                    end
                    return original_get_lang(ft)
                  end
                end
              end,
            },
          },
          
          -- 文件忽略规则
          file_ignore_patterns = { "node_modules", "%.git/", "dist/", "build/" },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            additional_args = function(_)
              return { "--hidden" }
            end,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
    end,
  },
}
