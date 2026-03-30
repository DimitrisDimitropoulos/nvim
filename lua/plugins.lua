---@type (string|vim.pack.Spec)[]
return {
  {
    src = 'https://github.com/neovim/nvim-lspconfig',
    data = {
      event = { 'BufReadPre', 'BufNewFile' },
      config = function()
        require 'lsp'
        require 'statusline'
      end,
    },
  },
  {
    src = 'https://github.com/lewis6991/gitsigns.nvim',
    data = {
      event = { 'BufReadPre', 'BufNewFile' },
      config = function()
        require 'plugins.configs.signs'
      end,
    },
  },
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
    data = {
      event = { 'BufReadPre', 'BufNewFile' },
      build = function()
        vim.cmd 'TSUpdate'
      end,
    },
  },
  {
    src = 'https://github.com/echasnovski/mini.splitjoin',
    data = {
      keys = { 'n', 'gS' },
      config = function()
        require('mini.splitjoin').setup {}
      end,
    },
  },
  {
    src = 'https://github.com/ibhagwan/fzf-lua',
    data = {
      keys = { 'n', '<leader>f' },
      cmd = 'FzfLua',
      config = function()
        require 'plugins.configs.fzf'
      end,
    },
  },
  {
    src = 'https://github.com/williamboman/mason.nvim',
    data = {
      cmd = 'Mason',
      config = function()
        require('mason').setup {
          PATH = 'skip',
          max_concurrent_installers = 20,
          ui = {
            icons = { package_installed = '', package_pending = '', package_uninstalled = '' },
          },
        }
      end,
    },
  },
}
