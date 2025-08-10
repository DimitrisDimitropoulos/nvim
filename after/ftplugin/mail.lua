vim.wo[0][0].spell = true
vim.o.showmode = true
vim.wo[0][0].colorcolumn = '80'

local mail_statline = {
  '%{nr2char(32)}', -- A space character.
  '%{&wrap ? "[WRAP]" : ""}', -- Show "SPELL" if spell checking is enabled.
  '%{nr2char(32)}', -- A space character.
  '%{&spell ? "[SPELL " . &spelllang . "]" : ""}', -- Show the current spell language.
  '%{nr2char(32)}', -- A space character.
  '[%{&fileencoding}]', -- Show the current file encoding.
  '%{nr2char(32)}', -- A space character.
  '[%{&filetype}]', -- Show the current file type.
  '%{nr2char(32)}', -- A space character.
  '%m', -- Show "--" if the file is modified.
  '%=', -- Align all items to right from this point on.
  'l: %l/%L %p%%', -- Current line number, total number of lines, and percentage through the file.
  '%{nr2char(32)}', -- A space character.
  'c: %-3c', -- Current column number.
}
vim.wo[0][0].statusline = table.concat(mail_statline)
