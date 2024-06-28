local map = vim.keymap.set

map({ 'i', 'n' }, '<C-s>', function()
  vim.cmd.write {}
end)
map('t', '<C-[><C-[>', '<C-\\><C-n>', { silent = true })
map('i', '<C-H>', '<C-w>')
map('i', '<C-BS>', '<C-w>')

map('n', '<leader>bd', function()
  vim.cmd 'bd'
end, { noremap = true, desc = 'delete buffer' })
map('n', '<leader>bn', function()
  vim.cmd 'bn'
end, { noremap = true, desc = 'next buffer' })
map('n', '<leader>bp', function()
  vim.cmd 'bp'
end, { noremap = true, desc = 'previous buffer' })

local arrows = { '<Up>', '<Down>', '<Left>', '<Right>' }
for _, arrow in ipairs(arrows) do
  map({ 'n', 'x', 'c' }, arrow, '')
end

map('n', '<leader>mm', function()
  vim.cmd 'make'
end, { noremap = true, desc = 'make' })
map('n', '<leader>mr', function()
  vim.cmd 'make run'
end, { noremap = true, desc = 'make run' })
map('n', '<leader>mc', function()
  vim.cmd 'make clean'
end, { noremap = true, desc = 'make clean' })
