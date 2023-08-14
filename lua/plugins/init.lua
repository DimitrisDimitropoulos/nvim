local map = vim.keymap.set

local plugins = {

  {
    "nvim-lua/plenary.nvim",
  },

  -- colorscheme
  {
    "savq/melange-nvim",
    lazy = false,
    enabled = false,
    name = "melange",
    priority = 1000,
    config = function() vim.cmd.colorscheme "melange" end,
  },

  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function() vim.cmd.colorscheme "catppuccin" end,
  },

  -- Statusline
  {
    "freddiehaddad/feline.nvim",
    event = "VeryLazy",
    config = function() require "plugins.configs.feline" end,
  },

  -- file tree
  {
    "nvim-tree/nvim-tree.lua",
    keys = "<C-b>",
    config = function()
      require("nvim-tree").setup(
        map("n", "<C-b>", function() require("nvim-tree.api").tree.toggle() end, { desc = "toggle nvimtree" })
      )
    end,
  },

  -- icons, for UI related plugins
  {
    "nvim-tree/nvim-web-devicons",
    config = function() require("nvim-web-devicons").setup() end,
  },

  -- syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function() require "plugins.configs.treesitter" end,
  },

  -- CMP config and dependencies
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- cmp sources
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "onsails/lspkind-nvim",

      -- snippets
      --list of default snippets
      "rafamadriz/friendly-snippets",

      -- snippets engine
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts) require("plugins.configs.luasnip").luasnip(opts) end,
      },

      -- autopairs , autocompletes ()[] etc
      {
        "windwp/nvim-autopairs",
        config = function()
          require("nvim-autopairs").setup()

          --  cmp integration
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          local cmp = require "cmp"
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
    },
    config = function() require "plugins.configs.cmp" end,
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    config = function() require "plugins.configs.mason" end,
  },

  -- lsp
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function() require "plugins.configs.lspconfig" end,
    dependencies = {
      {
        "creativenull/efmls-configs-nvim",
        version = "v0.2.x", -- tag is optional
      },
      -- {
      --   "nvimdev/guard.nvim",
      --   enabled = false,
      --   config = function() require "plugins.configs.guard" end,
      -- },
      -- {
      --   "jose-elias-alvarez/null-ls.nvim",
      --   enabled = false,
      --   config = function() require "plugins.configs.null" end,
      -- },
    },
  },

  -- indent lines
  {
    "lukas-reineke/indent-blankline.nvim",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function() require "plugins.configs.indent" end,
  },

  -- files finder etc
  {
    "nvim-telescope/telescope.nvim",
    keys = "<leader>f",
    cmd = "Telescope",
    config = function() require "plugins.configs.telescope" end,
    dependencies = {
      { "natecraddock/telescope-zf-native.nvim" },
    },
  },

  -- git status on signcolumn etc
  {
    "lewis6991/gitsigns.nvim",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function() require "plugins.configs.signs" end,
  },

  {
    "numToStr/Comment.nvim",
    keys = { "gc", "gb", "<leader>/", "V" },
    config = function() require "plugins.configs.comment" end,
  },

  {
    "github/copilot.vim",
    event = "InsertEnter",
  },

  -- {
  --   "zbirenbaum/copilot.lua",
  --   event = "InsertEnter",
  --   config = function()
  --     require("plugins.configs.copilot")
  --   end,
  -- },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot_cmp").setup()
  --   end,
  -- },

  {
    "beauwilliams/focus.nvim",
    lazy = true,
    event = "BufLeave",
    config = function() require("focus").setup() end,
  },
  {
    "goolord/alpha-nvim",
    lazy = false,
    config = function() require "plugins.configs.alpha" end,
  },
  {
    "echasnovski/mini.nvim",
    lazy = true,
    version = false,
    event = "InsertEnter",
    config = function() require "plugins.configs.mini" end,
  },
  {
    "folke/trouble.nvim",
    keys = "<leader>tr",
    lazy = true,
    config = function()
      require("trouble").setup(map("n", "<leader>tr", function() require("trouble").toggle() end, { desc = "trouble" }))
    end,
  },
  {
    "folke/which-key.nvim",
    keys = { "<leader>", '"', "'", "`", "c", "v" },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = function() return require "plugins.configs.whichkey" end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    ft = { "lua", "css", "scss" },
    config = function()
      require("colorizer").setup {
        filetypes = { "css", "javascript", "lua", "ini", html = { mode = "foreground" } },
      }
    end,
  },

  {
    "lervag/vimtex",
    ft = "tex",
  },
}

require("lazy").setup(plugins, require "plugins.configs.lazy")
