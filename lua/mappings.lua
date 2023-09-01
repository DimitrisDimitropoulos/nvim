local map = vim.keymap.set

map({ 'i', 'n' }, '<C-s>', function() vim.cmd.write {} end)
map('t', '<C-[><C-[>', '<C-\\><C-n>', { silent = true })
map('i', '<C-H>', '<C-W>')

-- vim.keymap.set('n', 'ZZ', function()
--   vim.o.timeout = true
--   vim.o.timeoutlen = 300
--   vim.cmd 'wqa'
-- end, { desc = 'save and quit', silent = false })
-- vim.keymap.set('n', 'ZQ', function()
--   vim.o.timeout = true
--   vim.o.timeoutlen = 300
--   vim.cmd 'qa!'
-- end, { desc = 'quit with no save', silent = false })

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
  map({ 'n', 'x', 'i', 'c' }, arrow, '')
end
