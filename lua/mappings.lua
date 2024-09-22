vim.keymap.set('n', '<C-s>', vim.cmd.write)
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

local function toggle_option(opt)
  vim.opt[opt] = not vim.opt[opt]:get()
end
vim.keymap.set('n', '<A-s>', function()
  toggle_option [[spell]]
end, { silent = false, noremap = true })
vim.keymap.set('n', '<A-z>', function()
  toggle_option [[wrap]]
end, { silent = false, noremap = true })
