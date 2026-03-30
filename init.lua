require 'options'
require 'mappings'
require 'commands'

vim.pack.add {
  'https://github.com/savq/melange-nvim',
  'https://github.com/rafamadriz/friendly-snippets',
}
vim.cmd.colorscheme 'melange'

require('lloader').lazy_load(require 'plugins')
