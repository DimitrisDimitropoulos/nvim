vim.keymap.set({ 'i', 'n' }, '<C-s>', function()
  vim.cmd.write {}
end)
vim.keymap.set('t', '<C-[><C-[>', '<C-\\><C-n>', { silent = true })

for _, b in ipairs { 'bd', 'bn', 'bp' } do
  vim.keymap.set('n', '<leader>' .. b, function()
    vim.cmd(b)
  end, { noremap = true, desc = b })
end

for _, arrow in ipairs { '<Up>', '<Down>', '<Left>', '<Right>' } do
  vim.keymap.set({ 'n', 'x', 'c' }, arrow, '')
end

vim.keymap.set('n', '<leader>mm', function()
  vim.cmd 'make'
end, { noremap = true, desc = 'make' })
