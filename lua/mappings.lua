local map = vim.keymap.set

map({ 'i', 'n' }, '<C-s>', function() vim.cmd.write {} end)
map('t', '<C-[><C-[>', '<C-\\><C-n>', { silent = true })
map('i', '<C-H>', '<C-W>')

local commands = {
  -- stylua: ignore start
  { key = '<leader>bd', cmd = 'bd', descr = 'delete' },
  { key = '<leader>bn', cmd = 'bn', descr = 'next' },
  { key = '<leader>bp', cmd = 'bp', descr = 'previous' },
  -- stylua: ignore stop
}
for _, command in ipairs(commands) do
  map('n', command.key, function() vim.cmd(command.cmd) end, { noremap = true, desc = 'buffer ' .. command.descr })
end

local arrows = { '<Up>', '<Down>', '<Left>', '<Right>' }
for _, arrow in ipairs(arrows) do
  map({ 'n', 'x', 'c' }, arrow, '')
end
