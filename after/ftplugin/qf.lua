vim.opt_local.relativenumber = false
vim.opt_local.wrap = false
vim.opt_local.spell = false
vim.opt_local.textwidth = 0
vim.opt_local.scrolloff = 0
vim.opt_local.buflisted = false
vim.opt_local.winfixbuf = true
local qf_statusline = {
  '%{nr2char(32)}', -- A space character.
  '%t', -- File name, either [Quickfix List] or [Location List].
  '%=', -- Align all items to right from this point on.
  '%l/%L', -- Current line number and total item count.
  '%{nr2char(32)}', -- A space character.
}
vim.opt_local.statusline = table.concat(qf_statusline)
