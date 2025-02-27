vim.g.mapleader = ' '
vim.g.tex_flavor = 'latex'
vim.g.border_style = 'rounded' ---@type string

local opt = vim.o

opt.langmap =
  'ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR,ΣS,ΤT,ΘU,ΩV,WW,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj,κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz'
opt.list = true
vim.opt.listchars = {
  eol = '\\U000021b5',
  tab = '  ',
  extends = '>',
  precedes = '<',
  trail = '\\U00002022',
  nbsp = '~',
}
opt.showbreak = '\u{21AA} '

opt.spelllang = 'el,en'
opt.spellsuggest = 'fast'
opt.spelloptions = 'camel'

opt.clipboard = 'unnamedplus'
if vim.fn.has 'unix' == 1 then
  if vim.fn.executable 'xclip' == 1 then
    vim.g.clipboard = {
      copy = { ['+'] = 'xclip -selection clipboard', ['*'] = 'xclip -selection clipboard' },
      paste = { ['+'] = 'xclip -selection clipboard -o', ['*'] = 'xclip -selection clipboard -o' },
    }
  end
  if vim.fn.executable 'xsel' == 1 then
    vim.g.clipboard = {
      copy = { ['+'] = 'xsel --clipboard', ['*'] = 'xsel --clipboard' },
      paste = { ['+'] = 'xsel --clipboard --output', ['*'] = 'xsel --clipboard --output' },
    }
  end
  if
    vim.fn.executable 'wl-copy' == 1
    and vim.fn.executable 'wl-paste' == 1
    and vim.fn.exists '$WAYLAND_DISPLAY' == 1
  then
    vim.g.clipboard = {
      copy = { ['+'] = 'wl-copy --type text/plain', ['*'] = 'wl-copy --primary --type text/plain' },
      paste = { ['+'] = 'wl-paste --no-newline', ['*'] = 'wl-paste --no-newline --primary' },
    }
  end
end
if vim.fn.has 'win32' == 1 or vim.fn.has 'wsl' == 1 then
  vim.g.clipboard = {
    copy = { ['+'] = 'win32yank.exe -i --crlf', ['*'] = 'win32yank.exe -i --crlf' },
    paste = { ['+'] = 'win32yank.exe -o --lf', ['*'] = 'win32yank.exe -o --lf' },
  }
end
if vim.fn.has 'win32' == 1 and vim.fn.executable 'pwsh.exe' == 1 then
  opt.shell = 'pwsh.exe'
  opt.shellxquote = ''
  opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
end
if vim.fn.executable 'rg' == 1 then
  opt.grepprg = 'rg --vimgrep --smart-case --hidden --color=never --glob !.git'
  opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
end

opt.path = opt.path .. '**'

opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.linebreak = true
opt.pumheight = 20
if vim.version().minor >= 11 then
  vim.opt.completeopt = { 'menuone', 'popup', 'noinsert', 'fuzzy' } -- noselect is broken
end

opt.diffopt = 'filler,internal,hiddenoff,algorithm:histogram,indent-heuristic,linematch:60,vertical'
opt.incsearch = true
opt.smartcase = true
opt.mouse = 'c'

opt.laststatus = 3
opt.showmode = true
opt.scrolloff = 3
opt.sidescrolloff = 3
opt.smoothscroll = true
opt.cursorlineopt = 'both'
opt.cursorline = true
opt.cursorcolumn = false
opt.number = false
opt.relativenumber = true
opt.numberwidth = 2
opt.ruler = true
opt.signcolumn = 'yes'

opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeout = true
opt.timeoutlen = 400
opt.undofile = true
opt.updatetime = 500

opt.foldcolumn = '1'
opt.fillchars = 'fold: ,foldopen:,foldsep: ,foldclose:'
opt.foldenable = true
opt.foldtext = ''
opt.foldlevel = 99
opt.foldlevelstart = 99

if vim.version().minor >= 11 then
  opt.statuscolumn =
    '%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "" : "") : " " }%l%s'
end

for _, provider in ipairs { 'node', 'perl', 'python3', 'ruby' } do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end

-- add binaries installed by mason.nvim to path
vim.env.PATH = vim.env.PATH .. (vim.g.is_windows and ';' or ':') .. vim.fn.stdpath 'data' .. '/mason/bin'

-- Neovide config
if vim.g.neovide then
  require 'neovide'
end
