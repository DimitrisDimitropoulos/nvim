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

local get_hl = require('utils.ui_utils').get_hl
vim.api.nvim_set_hl(0, 'IndentBlanklineContextStart', { bg = tostring(get_hl('Visual').background), bold = true })
