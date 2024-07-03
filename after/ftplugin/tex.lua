vim.opt_local.wrap = true

local function moving_wrap(direction)
  return (vim.v.count == 0) and 'g' .. direction or direction
end
vim.keymap.set({ 'n', 'x' }, 'k', function()
  return moving_wrap 'k'
end, { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'j', function()
  return moving_wrap 'j'
end, { expr = true, silent = true })

-- BUG: For some reason this does not work, @2024-01-25 01:51:09
vim.cmd.syntax 'spell toplevel'
