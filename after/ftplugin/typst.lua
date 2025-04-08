vim.api.nvim_create_user_command('GetTypstLabels', function()
  require('utils').gen_loclist(require('utils').get_entries('((label) @label)', 'typst'), 'Typst Labels')
end, { nargs = 0, desc = 'Generate a location list with Typst labels' })

vim.api.nvim_create_user_command('GetTypstHeadings', function()
  require('utils').gen_loclist(
    require('utils').get_entries('((section (heading (text) @text)))', 'typst'),
    'Typst Headings'
  )
end, { nargs = 0, desc = 'Generate a location list with Typst headings' })
