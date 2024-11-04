vim.keymap.set('n', '<C-s>', vim.cmd.write)

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

vim.keymap.set({ 'i', 's' }, '<A-j>', function()
  if vim.snippet.active { direction = 1 } then
    vim.schedule(function()
      vim.snippet.jump(1)
    end)
    return
  end
end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<A-k>', function()
  if vim.snippet.active { direction = -1 } then
    vim.schedule(function()
      vim.snippet.jump(-1)
    end)
    return
  end
end, { silent = true })

vim.keymap.set('x', '<leader>rl', '<cmd>g/^$/d<CR>', { noremap = true, desc = 'remove empty lines' })
