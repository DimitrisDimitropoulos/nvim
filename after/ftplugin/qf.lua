vim.wo[0][0].relativenumber = false
vim.wo[0][0].wrap = false
vim.wo[0][0].spell = false
vim.bo.textwidth = 0
vim.wo[0][0].scrolloff = 0
vim.bo.buflisted = false
vim.wo[0][0].winfixbuf = true
local qf_statusline = {
  '%{nr2char(32)}', -- A space character.
  '%t', -- File name, either [Quickfix List] or [Location List].
  '%{nr2char(32)}', -- A space character.
  '%{exists("w:quickfix_title") ? " " . w:quickfix_title : ""}', -- Quickfix title.
  '%=', -- Align all items to right from this point on.
  '%l/%L', -- Current line number and total item count.
  '%{nr2char(32)}', -- A space character.
}
vim.wo[0][0].statusline = table.concat(qf_statusline)

vim.cmd.packadd 'cfilter'
