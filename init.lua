vim.loader.enable()
require 'options'
require 'mappings'
require 'commands'
vim.cmd.colorscheme 'melange'
require('lloader').lazy_load(require 'plugins')

vim.pack.add { 'https://github.com/rafamadriz/friendly-snippets' }
