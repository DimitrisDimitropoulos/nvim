vim.opt.cursorlineopt = 'number'
vim.opt_local.spell = true
vim.opt_local.wrap = true

local function moving_wrap(direction) return (vim.v.count == 0) and 'g' .. direction or direction end
vim.keymap.set({ 'n', 'x' }, '<Up>', function() return moving_wrap 'k' end, { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Down>', function() return moving_wrap 'j' end, { expr = true, silent = true })
-- function() return (vim.v.count == 0) and "gj" or "j" end,
