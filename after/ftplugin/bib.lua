vim.wo[0][0].spell = true
vim.wo[0][0].colorcolumn = '80'

vim.api.nvim_create_user_command('GetBibEntries', function()
  require('utils').gen_loclist(
    require('utils').get_entries('(entry key: (key_brace) @key)', 'bibtex'),
    'Bibliography Entries'
  )
end, { nargs = 0, desc = 'Get the bibliography entries' })
