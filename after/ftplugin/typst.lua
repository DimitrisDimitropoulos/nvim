vim.api.nvim_create_user_command('GetTypstLabels', function()
  require('utils').gen_loclist(require('utils').get_entries('((label) @label)', 'typst'), 'Typst Labels')
end, { nargs = 0, desc = 'Generate a location list with Typst labels' })

vim.keymap.set('n', 'gO', function()
  require('utils').gen_loclist(
    require('utils').get_entries('((section (heading (text) @text)))', 'typst'),
    'Typst Headings'
  )
end, { silent = true, noremap = true, desc = 'User: show LaTeX TOC' })
