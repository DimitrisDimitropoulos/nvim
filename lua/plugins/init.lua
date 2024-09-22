--- @diagnostic disable: different-requires

local evs = { 'BufReadPre', 'BufNewFile' }

require('lazy').setup({

  {
    'savq/melange-nvim',
    enabled = true,
    lazy = false,
    init = function()
      vim.cmd.colorscheme 'melange'
    end,
  },

  {
    'rebelot/heirline.nvim',
    enabled = false,
    event = evs,
    config = function()
      require 'plugins.configs.heirline'
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    enabled = false,
    keys = { '<leader>f', '<leader>s' },
    cmd = 'Telescope',
    config = function()
      require 'plugins.configs.telescope'
    end,
    dependencies = { { 'nvim-lua/plenary.nvim' }, { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' } },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = evs,
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true, use_languagetree = true, additional_vim_regex_highlighting = false },
        indent = { enable = false },
        incremental_selection = { enable = false },
      }
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'saadparwaiz1/cmp_luasnip',
      -- 'hrsh7th/cmp-nvim-lua',

      {
        'L3MON4D3/LuaSnip',
        dependencies = { 'rafamadriz/friendly-snippets' },
        config = function()
          require 'plugins.configs.luasnip'
        end,
      },

      {
        'windwp/nvim-autopairs',
        config = function()
          require('nvim-autopairs').setup()
          require('cmp').event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
        end,
      },
    },
    config = function()
      require 'plugins.configs.cmp'
    end,
  },

  {
    'neovim/nvim-lspconfig',
    event = evs,
    config = function()
      require 'plugins.configs.lspconfig'
    end,
  },

  { 'williamboman/mason.nvim', cmd = 'Mason', opts = require 'plugins.configs.mason' },

  {
    'lewis6991/gitsigns.nvim',
    event = evs,
    config = function()
      require 'plugins.configs.signs'
    end,
  },

  {
    'numToStr/Comment.nvim',
    enabled = false,
    keys = { 'gc', 'gb' },
    opts = {},
  },

  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = {
          auto_trigger = true,
          debounce = 5,
          keymap = { accept = false },
        },
      }
      vim.keymap.set('i', '<Tab>', function()
        if require('copilot.suggestion').is_visible() then
          require('copilot.suggestion').accept()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false)
        end
      end, { silent = true, desc = 'copilot super Tab' })
    end,
  },

  {
    'echasnovski/mini.splitjoin',
    version = false,
    keys = 'gS',
    opts = {},
  },

  {
    'folke/which-key.nvim',
    enabled = false,
    keys = { '<leader>', '"', "'", '`', ',', 'c', 'v', '[', ']', 'g' },
    opts = {},
  },

  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    keys = { '<leader>f', '<leader>s' },
    config = function()
      require 'plugins.configs.fzf'
    end,
  },

  {
    'nvimdev/indentmini.nvim',
    enabled = false,
    event = evs,
    config = function()
      require('indentmini').setup { minlevel = 2 }
      vim.api.nvim_set_hl(0, 'IndentLine', { link = 'IblIndent' })
      vim.api.nvim_set_hl(0, 'IndentLineCurrent', { link = 'Keyword' })
    end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    cmd = 'ColorizerAttachToBuffer',
    opts = {},
  },
}, require 'plugins.configs.lazy')
