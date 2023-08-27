vim.g.mapleader = ' '
vim.g.do_filetype_lua = 1

local opt = vim.opt

opt.syntax = 'off'
opt.incsearch = true

opt.spelllang = 'el,en'
opt.laststatus = 3
opt.showmode = false
opt.scrolloff = 3
opt.sidescrolloff = 3

vim.opt.numberwidth = 3
opt.cursorlineopt = 'number'
-- opt.cursorline = true
opt.cursorcolumn = false
opt.clipboard = 'unnamedplus'

opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.ignorecase = true
opt.smartcase = true
opt.mouse = 'c'

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true
opt.ruler = false

-- disable nvim intro
opt.shortmess:append 'sI'

opt.signcolumn = 'yes'
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true
opt.updatetime = 250

-- disable some default providers
local providers = { 'node', 'perl', 'python3', 'ruby' }
for _, provider in ipairs(providers) do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'
vim.env.PATH = vim.env.PATH .. (is_windows and ';' or ':') .. vim.fn.stdpath 'data' .. '/mason/bin'
