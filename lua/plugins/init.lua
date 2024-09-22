--- @diagnostic disable: different-requires
local map = vim.keymap.set

local plugins = {

  {
    'savq/melange-nvim',
    lazy = false,
    enabled = false,
    name = 'melange',
    priority = 1000,
    config = function() vim.cmd.colorscheme 'melange' end,
  },

  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme 'tokyonight-storm' end,
  },

  {
    'rebelot/heirline.nvim',
    -- enabled = false,
    event = 'BufReadPre',
    -- priority = 900,
    -- lazy = false,
    config = function() require 'plugins.configs.heirline' end,
  },

  {
    'nvim-tree/nvim-web-devicons',
    config = function() require('nvim-web-devicons').setup() end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function() require 'plugins.configs.treesitter' end,
  },

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- cmp sources
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lua',
      -- 'onsails/lspkind-nvim',

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
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    cmd = { 'Mason' },
    config = function() require 'plugins.configs.mason' end,
  },

  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function() require 'plugins.configs.lsp' end,
    dependencies = {

      -- { 'DimitrisDimitropoulos/efmls-configs-nvim', branch = 'add-formatters-fix-cppcheck' },

      -- {
      --   'mfussenegger/nvim-lint',
      --   config = function()
      --     require('lint').linters_by_ft = {
      --       python = { 'mypy', 'ruff' },
      --     }
      --     vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost' }, {
      --       callback = function()
      --         local lint_status, lint = pcall(require, 'lint')
      --         if lint_status then lint.try_lint() end
      --       end,
      --     })
      --   end,
      -- },
      --

      --
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function() require 'plugins.configs.indent' end,
  },

  {
    'nvim-telescope/telescope.nvim',
    keys = { '<leader>f' },
    cmd = 'Telescope',
    config = function() require 'plugins.configs.telescope' end,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'natecraddock/telescope-zf-native.nvim' },
      { 'nvim-telescope/telescope-file-browser.nvim' },
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function() require 'plugins.configs.signs' end,
  },

  {
    'numToStr/Comment.nvim',
    keys = { 'gc', 'gb', '<leader>/', 'V' },
    config = function() require 'plugins.configs.comment' end,
  },

  {
    'goolord/alpha-nvim',
    enabled = false,
    lazy = true,
    config = function() require 'plugins.configs.alpha' end,
  },

  {
    'echasnovski/mini.nvim',
    version = false,
    event = 'InsertEnter',
    config = function() require 'plugins.configs.mini' end,
  },

  {
    'folke/trouble.nvim',
    keys = '<leader>tr',
    cmd = 'Trouble',
    config = function()
      require('trouble').setup(map('n', '<leader>tr', function() require('trouble').toggle() end, { desc = 'trouble' }))
    end,
  },

  {
    'folke/which-key.nvim',
    keys = { '<leader>', '"', "'", '`', 'c', 'v' },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = function() return require 'plugins.configs.whichkey' end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    enabled = false,
    config = function()
      require('colorizer').setup {
        filetypes = { 'css', 'javascript', 'lua', 'ini', html = { mode = 'foreground' } },
      }
    end,
  },

  {
    'lervag/vimtex',
    enabled = false,
    ft = 'tex',
    config = function() require 'plugins.configs.vimtex' end,
  },
  {
    'github/copilot.vim',
    event = 'InsertEnter',
  },
}

require('lazy').setup(plugins, require 'plugins.configs.lazy')
