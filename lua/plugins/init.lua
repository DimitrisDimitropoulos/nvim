local plugins = {
  "nvim-lua/plenary.nvim",

  -- colorscheme
  {
    "savq/melange-nvim",
    -- "ellisonleao/gruvbox.nvim",
    -- "catppuccin/nvim",
    -- name = "catppuccin",
    name = "melange",
    priority = 1000,
  },

  -- file tree
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup()
    end,
  },

  -- icons, for UI related plugins
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },

  -- syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("plugins.configs.treesitter")
    end,
  },

  -- {
  --   "nvim-lualine/lualine.nvim",
  --   lazy = false,
  --   config = function()
  --     require("plugins.configs.lualine")
  --   end,
  -- },

  {
    "freddiehaddad/feline.nvim",
    lazy = false,
    config = function()
      require("plugins.configs.feline")
    end,
  },

  -- -- statusline
  -- {
  --   "rebelot/heirline.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("plugins.configs.heirline")
  --   end,
  -- },

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
        config = function(_, opts)
          require("plugins.configs.luasnip").luasnip(opts)
        end,
      },

      -- autopairs , autocompletes ()[] etc
      {
        "windwp/nvim-autopairs",
        config = function()
          require("nvim-autopairs").setup()

          --  cmp integration
          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          local cmp = require("cmp")
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
    },
    config = function()
      require("plugins.configs.cmp")
    end,
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonInstallAll",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    config = function()
      local apps = require("plugins.configs.mason")
      require("plugins.configs.mason")
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(apps.ensure_installed, " "))
      end, {})
      vim.g.mason_binaries_list = apps.ensure_installed
    end,
  },

  -- lsp
  {
    "neovim/nvim-lspconfig",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      require("plugins.configs.lspconfig")
    end,
    dependencies = {
      -- formatting , linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require("plugins.configs.null")
        end,
      },
    },
  },

  -- indent lines
  {
    "lukas-reineke/indent-blankline.nvim",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
  },

  -- files finder etc
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = function()
      require("plugins.configs.telescope")
    end,
  },
  {
    "natecraddock/telescope-zf-native.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
  },

  -- git status on signcolumn etc
  {
    "lewis6991/gitsigns.nvim",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      require("gitsigns").setup()
    end,
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      "gc",
      "gb",
    },
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "github/copilot.vim",
    event = "InsertEnter",
  },
  {
    "beauwilliams/focus.nvim",
    event = "BufLeave",
    -- keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>", "<C-w>" },
    -- keys = {"<leader>qf"},
    config = function()
      require("focus").setup()
    end,
  },
  {
    "goolord/alpha-nvim",
    enabled = true,
    lazy = false,
    config = function()
      require("plugins.configs.alpha")
    end,
  },
  {
    "echasnovski/mini.nvim",
    version = false,
    event = "InsertEnter",
    config = function()
      require("plugins.configs.other")
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    lazy = true,
    config = function()
      require("trouble").setup()
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
  },
  {
    "lervag/vimtex",
    ft = "tex",
  },
}

require("lazy").setup(plugins, require("plugins.configs.lazy"))
