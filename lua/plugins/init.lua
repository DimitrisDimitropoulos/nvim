--- @diagnostic disable: different-requires

local evs = { 'BufReadPre', 'BufNewFile' }

local plugins = {

  {
    'savq/melange-nvim',
    enabled = true,
    lazy = false,
    config = function()
      vim.cmd.colorscheme 'melange'
    end
  },
  {
    'folke/tokyonight.nvim',
    enabled = false,
    lazy = false,
    config = function()
      vim.cmd.colorscheme 'tokyonight-storm'
    end
  },
  {
    'goolord/alpha-nvim',
    enabled = true,
    event = 'VimEnter',
    config = function()
      require 'plugins.configs.alpha'
    end
  },
  {
    'rebelot/heirline.nvim',
    event = 'VeryLazy',
    config = function()
      require 'plugins.configs.heirline'
    end
  },
  { 'nvim-tree/nvim-web-devicons', config = function() require('nvim-web-devicons').setup() end },

  {
    'nvim-telescope/telescope.nvim',
    keys = { '<leader>f', '<leader>s' },
    cmd = 'Telescope',
    config = function() require 'plugins.configs.telescope' end,
    dependencies = { { 'nvim-lua/plenary.nvim' }, { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' } },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = evs,
    config = function() require 'plugins.configs.treesitter' end,
  },

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'saadparwaiz1/cmp_luasnip',
      -- 'hrsh7th/cmp-nvim-lua',

      {
        'L3MON4D3/LuaSnip',
        dependencies = { 'rafamadriz/friendly-snippets' },
        config = function() require 'plugins.configs.luasnip' end,
      },

      {
        'windwp/nvim-autopairs',
        config = function()
          require('nvim-autopairs').setup()
          local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
          local cmp = require 'cmp'
          cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end,
      },
    },
    config = function() require 'plugins.configs.cmp' end,
  },

  {
    'neovim/nvim-lspconfig',
    event = evs,
    config = function()
      require 'plugins.configs.lsp'
    end
  },

  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    config = function()
      require 'plugins.configs.mason'
    end
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    enabled = false,
    version = '2.20.7',
    event = evs,
    config = function() require 'plugins.configs.indent' end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = evs,
    config = function()
      require 'plugins.configs.signs'
    end
  },

  {
    'numToStr/Comment.nvim',
    enabled = false,
    keys = { 'gc', 'gb', '<leader>/', 'V' },
    config = function() require 'plugins.configs.comment' end,
  },

  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup { suggestion = { auto_trigger = true, debounce = 5, keymap = { accept = '<S-Tab>' } } }
    end,
  },

  {
    'echasnovski/mini.splitjoin',
    version = false,
    keys = 'gS',
    config = function() require('mini.splitjoin').setup() end,
  },

  {
    'folke/which-key.nvim',
    enabled = false,
    keys = { '<leader>', '"', "'", '`', ',', 'c', 'v', '[', ']', 'g' },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = require 'plugins.configs.whichkey',
  },

  {
    'NvChad/nvim-colorizer.lua',
    cmd = 'ColorizerAttachToBuffer',
    config = function() require('colorizer').setup() end,
  },
}

require('lazy').setup(plugins, require 'plugins.configs.lazy')
