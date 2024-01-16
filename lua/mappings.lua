local map = vim.keymap.set

map({ 'i', 'n' }, '<C-s>', function() vim.cmd.write {} end)
map('t', '<C-[><C-[>', '<C-\\><C-n>', { silent = true })
map('i', '<C-H>', '<C-W>')

local commands = {
  { key = '<leader>bd', cmd = 'bd', descr = 'delete' },
  { key = '<leader>bn', cmd = 'bn', descr = 'next' },
  { key = '<leader>bp', cmd = 'bp', descr = 'previous' },
}
for _, command in ipairs(commands) do
  map('n', command.key, function() vim.cmd(command.cmd) end, { noremap = true, desc = 'buffer ' .. command.descr })
end

local arrows = { '<Up>', '<Down>', '<Left>', '<Right>' }
for _, arrow in ipairs(arrows) do
  map({ 'n', 'x', 'c' }, arrow, '')
end

map('n', '<leader>mm', function() vim.cmd 'make' end, { noremap = true, desc = 'make' })
map('n', '<leader>mr', function() vim.cmd 'make run' end, { noremap = true, desc = 'make run' })
map('n', '<leader>mc', function() vim.cmd 'make clean' end, { noremap = true, desc = 'make clean' })
