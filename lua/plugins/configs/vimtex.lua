local g = vim.g
-- VimTeX options
g.vimtex_quickfix_mode = 0
g.vimtex_syntax_enabled = 0
-- vim.cmd "let g:vimtex_syntax_enabled = v:false"
g.vimtex_complete_enabled = 0
g.Tex_BibtexFlavor = 'biber'
g.vimtex_view_method = 'zathura'
g.latex_view_general_viewer = 'zathura'
g.vimtex_compiler_progname = 'nvr'
g.tex_flavor = 'latex'

vim.keymap.set('n', 'K', '<nop>', { nowait = true })

local vimtex_keymap = {
  -- stylua: ignore start
  { key = 'll', cmd = 'Compile',   decr = 'compile' },
  { key = 'to', cmd = 'TocToggle', decr = 'toggle table of contents' },
  { key = 'lv', cmd = 'View',      decr = 'synctex' },
  { key = 'lr', cmd = 'Errors',    decr = 'errors' },
  -- stylua: ignore stop
}
for _, vitex in ipairs(vimtex_keymap) do
  vim.keymap.set('n', '<leader>' .. vitex.key, function() vim.cmd('Vimtex' .. vitex.cmd) end, { desc = vitex.decr })
end
