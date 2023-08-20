require('indent_blankline').setup {
  indentLine_enabled = 1,
  filetype_exclude = {
    'help',
    'terminal',
    'lazy',
    'lspinfo',
    'TelescopePrompt',
    'TelescopeResults',
    'mason',
    'alpha',
    '',
  },
  buftype_exclude = { 'terminal' },
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  show_current_context = true,
  show_current_context_start = true,
  indent_blankline_use_treesitter = true,
}

local ui_utils = require 'utils.ui_utils'
-- Set the hightlight group
vim.api.nvim_set_hl(
  0,
  'IndentBlanklineContextStart',
  { bg = tostring(ui_utils.get_hl('Visual').background), bold = true }
)
