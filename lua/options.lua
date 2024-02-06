vim.g.mapleader = ' '

local opt = vim.opt

opt.langmap =
  'ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR,ΣS,ΤT,ΘU,ΩV,WW,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj,κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz'

-- opt.list = true
-- opt.listchars = { eol = '\\U000021b5' }

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

if vim.fn.has 'unix' == 1 then
  if vim.fn.executable 'xclip' == 1 then
    vim.g.clipboard = {
      copy = { ['+'] = 'xclip -selection clipboard', ['*'] = 'xclip -selection clipboard' },
      paste = { ['+'] = 'xclip -selection clipboard -o', ['*'] = 'xclip -selection clipboard -o' },
    }
  end
end

if vim.fn.has 'win32' == 1 or vim.fn.has 'wsl' == 1 then
  vim.g.clipboard = {
    copy = { ['+'] = 'win32yank.exe -i --crlf', ['*'] = 'win32yank.exe -i --crlf' },
    paste = { ['+'] = 'win32yank.exe -o --lf', ['*'] = 'win32yank.exe -o --lf' },
  }
end

opt.foldenable = false

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

opt.shortmess:append 'sI'
opt.fillchars = { eob = ' ' }

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

-- Neovide config
if vim.g.neovide then
  local G = vim.g
  G.neovide_scroll_animation_length = 0
  G.neovide_refresh_rate = 60
  G.neovide_touch_drag_timeout = 0
  G.neovide_cursor_animation_length = 0
  G.neovide_cursor_trail_size = 0
  G.neovide_cursor_antialiasing = true
  G.neovide_cursor_animate_in_insert_mode = false
  G.neovide_cursor_vfx_mode = ''
  G.neovide_padding_top = 0
  G.neovide_padding_bottom = 0
  G.neovide_padding_right = 0
  G.neovide_padding_left = 0

  G.gui_font_default_size = 19
  G.gui_font_size = vim.g.gui_font_default_size
  G.gui_font_face = 'Comic Code,CaskaydiaCove Nerd Font'

  local set_guifont = function() vim.opt.guifont = string.format('%s:h%s', vim.g.gui_font_face, vim.g.gui_font_size) end

  local resize_guifont = function(delta)
    G.gui_font_size = G.gui_font_size + delta
    set_guifont()
  end

  local reset_guifont = function()
    G.gui_font_size = G.gui_font_default_size
    set_guifont()
  end

  -- Call function on startup to set default value
  reset_guifont()

  local opts = { noremap = true, silent = true }
  vim.keymap.set('n', '<C-+>', function() resize_guifont(1) end, opts)
  vim.keymap.set('n', '<C-->', function() resize_guifont(-1) end, opts)
  vim.keymap.set('n', '<C-0>', function() reset_guifont() end, opts)
end
