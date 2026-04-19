return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- 1) Mason
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd" },
        automatic_installation = true,
      })

      -- 2) LSP capabilities (blink.cmp)
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local lsp = vim.lsp
      local servers = { "lua_ls", "clangd" }

      for _, server in ipairs(servers) do
        local opts = { capabilities = capabilities }

        if server == "lua_ls" then
          opts.settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
            },
          }
        end

        if server == "clangd" then
          -- clangd 配置
          opts.cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
          }

          -- clangd inlay hints 设置
          -- 注意：这里保持 Enabled = true，因为我们需要 LSP 提供数据
          -- 但通过客户端控制是否显示
          opts.init_options = {
            clangdFileStatus = false,
          }

          opts.settings = {
            clangd = {
              InlayHints = {
                Enabled = true,      -- LSP 仍然生成 inlay hint 数据
                DeducedTypes = true, -- auto 后显示推导类型
                ParameterNames = true,
                Designators = true,
              },
            },
          }
        end

        if lsp.config then
          -- Neovim 0.11+
          lsp.config(server, opts)
          vim.lsp.enable(server)
        else
          -- Neovim 0.10 及以下
          require("lspconfig")[server].setup(opts)
        end
      end

      -- 3) LspAttach: 默认禁用 inlay hints，但保留数据
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.server_capabilities.inlayHintProvider then
            -- 默认禁用 inlay hints 显示
            vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
          end
        end,
      })

      -- 4) 快捷键：切换 inlay hints
      vim.keymap.set("n", "<leader>ih", function()
        local buf = vim.api.nvim_get_current_buf()
        local enabled = vim.lsp.inlay_hint.is_enabled({ buf = buf })
        vim.lsp.inlay_hint.enable(not enabled, { buf = buf })
        vim.notify("Inlay Hints: " .. (not enabled and "Enabled" or "Disabled"),
          not enabled and vim.log.levels.INFO or vim.log.levels.WARN)
      end, { desc = "Toggle Inlay Hints" })

      -- 5) 其他 LSP 快捷键
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
      vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
    end,
  },

  {
    "saghen/blink.cmp",
    version = "*",
    build = vim.fn.executable("cargo") == 1 and "cargo build --release" or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            min_keyword_length = 1,
          },
        },
      },
      completion = {
        accept = {
          auto_brackets = { enabled = true },
        },
        menu = {
          auto_show = true,
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon", "kind",             gap = 1 },
              { "label",     "label_description" },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      snippets = {
        active = function() return true end,
      },
    },
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup()
    end
  },
  { "williamboman/mason-lspconfig.nvim", config = function() require("mason-lspconfig").setup() end },
}
