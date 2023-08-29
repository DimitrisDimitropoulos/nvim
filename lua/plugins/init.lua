--- @diagnostic disable: different-requires

local evs = { 'BufReadPre', 'BufNewFile' }

local plugins = {

  { 'savq/melange-nvim', lazy = false, config = function() vim.cmd.colorscheme 'melange' end },

  { 'goolord/alpha-nvim', event = 'VimEnter', config = function() require 'plugins.configs.alpha' end },

  { 'rebelot/heirline.nvim', event = 'VeryLazy', config = function() require 'plugins.configs.heirline' end },

  { 'nvim-tree/nvim-web-devicons', config = function() require('nvim-web-devicons').setup() end },

  {
    'nvim-telescope/telescope.nvim',
    keys = { '<leader>f' },
    cmd = 'Telescope',
    config = function() require 'plugins.configs.telescope' end,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-file-browser.nvim' },
    },
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
      'hrsh7th/cmp-nvim-lua',

      {
        'L3MON4D3/LuaSnip',
        dependencies = 'rafamadriz/friendly-snippets',
        opts = {
          history = true,
          updateevents = 'TextChanged,TextChangedI',
          delete_check_events = 'TextChanged',
          enable_autosnippets = true,
        },
        config = function(_, opts) require('plugins.configs.luasnip').luasnip(opts) end,
      },

      {
        'windwp/nvim-autopairs',
        config = function()
          require('nvim-autopairs').setup()

          --  cmp integration
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
    config = function() require 'plugins.configs.lsp' end,
    dependencies = {
      {
        'mfussenegger/nvim-lint',
        -- enabled = false,
        config = function()
          require('lint').linters_by_ft = { python = { 'ruff' } }
          vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'BufReadPre', 'InsertEnter' }, {
            group = vim.api.nvim_create_augroup('Lint', { clear = true }),
            callback = function()
              local lint_status, lint = pcall(require, 'lint')
              if lint_status then lint.try_lint() end
            end,
            desc = 'lint setup',
          })
        end,
      },
    },
  },

  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    cmd = 'Mason',
    config = function() require 'plugins.configs.mason' end,
  },

  { 'lukas-reineke/indent-blankline.nvim', event = evs, config = function() require 'plugins.configs.indent' end },

  { 'lewis6991/gitsigns.nvim', event = evs, config = function() require 'plugins.configs.signs' end },

  {
    'numToStr/Comment.nvim',
    keys = { 'gc', 'gb', '<leader>/', 'V' },
    config = function() require 'plugins.configs.comment' end,
  },

  {
    'echasnovski/mini.nvim',
    version = false,
    event = 'InsertEnter',
    config = function() require 'plugins.configs.mini' end,
  },

  {
    'folke/which-key.nvim',
    keys = { '<leader>', '"', "'", '`', ',', 'c', 'v' },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = function() return require 'plugins.configs.whichkey' end,
  },

  {
    'folke/trouble.nvim',
    enabled = false,
    keys = '<leader>tr',
    cmd = 'Trouble',
    config = function()
      local map = vim.keymap.set
      require('trouble').setup(map('n', '<leader>tr', function() require('trouble').toggle() end, { desc = 'trouble' }))
    end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    enabled = false,
    config = function()
      require('colorizer').setup { filetypes = { 'css', 'javascript', 'lua', 'ini', html = { mode = 'foreground' } } }
    end,
  },

  { 'lervag/vimtex', enabled = false, ft = 'tex', config = function() require 'plugins.configs.vimtex' end },

  { 'github/copilot.vim', event = 'InsertEnter' },
}

require('lazy').setup(plugins, require 'plugins.configs.lazy')
