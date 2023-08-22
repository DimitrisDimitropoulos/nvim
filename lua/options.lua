vim.g.mapleader = ' '

local opt = vim.opt
local g = vim.g

-- performance
g.do_filetype_lua = 1
opt.syntax = 'off'

opt.spelllang = 'el,en'
opt.laststatus = 3 -- global statusline
opt.showmode = false
opt.scrolloff = 3
opt.sidescrolloff = 3

vim.opt.numberwidth = 3
-- vim.opt.statuscolumn = "%=%{ &nu? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s"
-- opt.cursorlineopt = 'number'
opt.cursorline = true
opt.cursorcolumn = false
vim.opt_local.cursorcolumn = false
opt.clipboard = 'unnamedplus'

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

-- vim.opt.fillchars = { eob = ' ' }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = 'c' -- disable the mouse

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true
opt.ruler = false

-- disable nvim intro
-- opt.shortmess:append 'sI'

opt.signcolumn = 'yes'
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true
opt.updatetime = 250

-- LuaSnip paths
g.vscode_snippets_path = '~/.config/nvim/snippets/json_snippets/'
g.lua_snippets_path = '~/.config/nvim/snippets/lua_snippets/'

-- disable some default providers
local providers = { 'node', 'perl', 'python3', 'ruby' }
for _, provider in ipairs(providers) do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'
vim.env.PATH = vim.env.PATH .. (is_windows and ';' or ':') .. vim.fn.stdpath 'data' .. '/mason/bin'
