local opt = vim.opt

vim.g.mapleader = " "
opt.laststatus = 3 -- global statusline
opt.showmode = false

opt.cursorline = true
opt.clipboard = "unnamedplus"

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true
opt.ruler = false

-- disable nvim intro
opt.shortmess:append("sI")

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

opt.timeoutlen = 400
opt.updatetime = 250

vim.g.vscode_snippets_path = "~/.config/nvim/snippets/"

-- disable some default providers
for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- add binaries installed by mason.nvim to path
-- local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
-- vim.env.PATH = vim.env.PATH .. (is_windows and ";" or ":") .. vim.fn.stdpath("data") .. "/mason/bin"
