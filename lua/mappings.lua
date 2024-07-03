local map = vim.keymap.set

map({ 'i', 'n' }, '<C-s>', function()
  vim.cmd.write {}
end)
map('t', '<C-[><C-[>', '<C-\\><C-n>', { silent = true })

local buf = { 'bd', 'bn', 'bp' }
for _, b in ipairs(buf) do
  map('n', '<leader>' .. b, function()
    vim.cmd(b)
  end, { noremap = true, desc = b })
end

local arrows = { '<Up>', '<Down>', '<Left>', '<Right>' }
for _, arrow in ipairs(arrows) do
  map({ 'n', 'x', 'c' }, arrow, '')
end

map('n', '<leader>mm', function()
  vim.cmd 'make'
end, { noremap = true, desc = 'make' })
