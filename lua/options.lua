vim.g.mapleader = ' '

-- vim.g.netrw_banner = 0
-- vim.g.netrw_liststyle = 3
-- vim.g.netrw_altv = 1

local opt = vim.opt

opt.incsearch = true

opt.spelllang = 'el,en'
opt.laststatus = 3
opt.showmode = false
opt.scrolloff = 3
opt.sidescrolloff = 3

opt.numberwidth = 3
opt.cursorlineopt = 'both'
opt.cursorline = true
opt.cursorcolumn = false
opt.clipboard = 'unnamedplus'
vim.g.clipboard = {
  copy = { ['+'] = 'xclip -selection clipboard', ['*'] = 'xclip -selection clipboard' },
  paste = { ['+'] = 'xclip -selection clipboard -o', ['*'] = 'xclip -selection clipboard -o' },
}

vim.opt.foldenable = false

opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.linebreak = true
opt.pumheight = 10

opt.ignorecase = true
opt.smartcase = true
opt.mouse = 'c'

opt.number = false
opt.relativenumber = true
opt.numberwidth = 2
opt.ruler = true

-- opt.shortmess:append 'sI'
-- opt.fillchars = { eob = ' ' }

opt.signcolumn = 'yes'
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true
opt.updatetime = 250

local providers = { 'node', 'perl', 'python3', 'ruby' }
for _, provider in ipairs(providers) do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'
vim.env.PATH = vim.env.PATH .. (is_windows and ';' or ':') .. vim.fn.stdpath 'data' .. '/mason/bin'
