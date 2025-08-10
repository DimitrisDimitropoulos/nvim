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
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = evs,
    branch = 'main',
  },

  {
    'saghen/blink.cmp',
    enabled = true,
    version = '*',
    event = 'InsertEnter',
    opts = require 'plugins.configs.blink',
  },

  {
    'DimitrisDimitropoulos/yasp.nvim',
    enabled = false,
    event = 'InsertEnter',
    opts = {
      trigger_chars = {
        ['*'] = { '{', '(', '[', ' ', '.', ':', ',' },
        ['lua'] = { '.', ':' },
      },
      descs = { 'FR', 'USR' },
      paths = {
        vim.fn.stdpath 'data' .. '/lazy/friendly-snippets/package.json',
        vim.fn.expand('$MYVIMRC'):match '(.*[/\\])' .. 'snippets/json_snippets/package.json',
      },
    },
  },

  { 'rafamadriz/friendly-snippets' },

  {
    'neovim/nvim-lspconfig',
    event = evs,
  },

  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {
      PATH = 'skip',
      max_concurrent_installers = 20,
      ui = {
        icons = { package_installed = '', package_pending = '', package_uninstalled = '' },
      },
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    event = evs,
    config = function()
      require 'plugins.configs.signs'
    end,
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
          hide_during_completion = false,
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
    'brenoprata10/nvim-highlight-colors',
    -- lua_ls and others supports documentColor, which is builtin in 0.12,
    -- granding this plugin uneeded
    enabled = vim.fn.has 'nvim-0.12' ~= 1,
    cmd = 'HighlightColors',
    opts = {},
  },
}, {
  install = { colorscheme = { 'melange' } },
  defaults = { lazy = true },
  rocks = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        '2html_plugin',
        'tohtml',
        'getscript',
        'getscriptPlugin',
        'gzip',
        'netrw',
        'netrwPlugin',
        'netrwSettings',
        'netrwFileHandlers',
        'tar',
        'tarPlugin',
        'spellfile_plugin',
        'zip',
        'zipPlugin',
        'tutor',
        'rplugin',
        'syntax',
        'synmenu',
        'optwin',
        'bugreport',
        'matchit',
      },
    },
  },
})
