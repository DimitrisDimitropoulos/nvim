local map = vim.keymap.set

map({ 'i', 'n' }, '<C-s>', function() vim.cmd 'w' end)
map('t', '<C-[><C-[>', '<C-\\><C-n>', { silent = true })
map('n', '<C-]><C-]>', function() vim.cmd 'bd!' end, { silent = true })

vim.keymap.set('n', 'ZZ', function()
  vim.o.timeout = true
  vim.o.timeoutlen = 300
  vim.cmd 'wqa'
end, { desc = 'save and quit', silent = false })
vim.keymap.set('n', 'ZQ', function()
  vim.o.timeout = true
  vim.o.timeoutlen = 300
  vim.cmd 'qa!'
end, { desc = 'quit with no save', silent = false })

local commands = {
  -- stylua: ignore start
  { key = "<ESC>",      cmd = "nohl"      },
  { key = "<leader>bd", cmd = "bd"        },
  { key = "<TAB>",      cmd = "bnext"     },
  { key = "<S-Tab>",    cmd = "bprevious" },
  -- stylua: ignore stop
}
for _, command in ipairs(commands) do
  map('n', command.key, function() vim.cmd(command.cmd) end, { noremap = true })
end
