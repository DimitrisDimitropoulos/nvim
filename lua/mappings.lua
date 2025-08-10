vim.keymap.set('n', '<C-s>', vim.cmd.write)

vim.keymap.set('n', '<leader>bd', function()
  vim.cmd 'bd'
end, { noremap = true, desc = 'delete buffer' })

for _, arrow in ipairs { '<Up>', '<Down>', '<Left>', '<Right>' } do
  vim.keymap.set({ 'n', 'x', 'c' }, arrow, '')
end

vim.keymap.set('n', '<leader>mm', function()
  vim.cmd 'make'
end, { noremap = true, desc = 'make' })

local function toggle_option(opt)
  vim.o[opt] = not vim.o[opt]
end
vim.keymap.set('n', '<A-s>', function()
  toggle_option [[spell]]
end, { silent = false, noremap = true })
vim.keymap.set('n', '<A-z>', function()
  toggle_option [[wrap]]
end, { silent = false, noremap = true })

vim.keymap.set('n', 'z=', function()
  vim.ui.select(vim.fn.spellsuggest(vim.fn.expand '<cword>'), {
    prompt = 'Select a word: ',
    format_item = function(item)
      return item
    end,
  }, function(choice)
    if not choice then
      return
    end
    vim.cmd('normal! "_ciw' .. choice)
  end)
end, { noremap = true, desc = 'spellsuggest' })

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
vim.keymap.set({ 'i', 's', 'n' }, '<A-c>', function()
  vim.snippet.stop()
end, { silent = true })

vim.keymap.set('x', '<leader>rl', ":<C-u>'<,'>g/^$/d<CR>", { noremap = true, desc = 'remove empty lines' })
