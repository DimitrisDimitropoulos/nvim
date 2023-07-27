local opt = vim.opt
local g = vim.g

local signs = {
  { hl = "DiagnosticSignError", txt = "■" },
  { hl = "DiagnosticSignWarn", txt = "△" },
  { hl = "DiagnosticSignInfo", txt = "○" },
  { hl = "DiagnosticSignHint", txt = "󰨔" },
}
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.hl, { text = sign.txt, texthl = sign.hl })
end

vim.diagnostic.config {
  underline = true,
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  float = {
    source = "always",
    border = "rounded",
    show_header = true,
  },
}

g.do_filetype_lua = 1

opt.spelllang = "el,en"
g.mapleader = " "
opt.laststatus = 3 -- global statusline
opt.showmode = false

vim.opt.numberwidth = 3
vim.opt.statuscolumn =
  "%=%{ &nu? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s"
opt.cursorlineopt = "number"
opt.cursorcolumn = false
vim.opt_local.cursorcolumn = false
opt.clipboard = "unnamedplus"

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

-- opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true
opt.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

opt.timeoutlen = 400
opt.updatetime = 250

-- VimTeX options
g.vimtex_quickfix_mode = 0
g.Tex_BibtexFlavor = "biber"
g.vimtex_view_method = "zathura"
g.vimtex_syntax_enabled = 0

-- LuaSnip options
g.vscode_snippets_path = "~/.config/nvim/snippets/"
g.lua_snippets_path = "~/.config/nvim/lua_snippets/"

-- disable some default providers
local providers = { "node", "perl", "python3", "ruby" }
for _, provider in ipairs(providers) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.env.PATH
  .. (is_windows and ";" or ":")
  .. vim.fn.stdpath "data"
  .. "/mason/bin"
