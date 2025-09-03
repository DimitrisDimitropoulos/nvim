vim.g.mapleader = ' '
vim.g.tex_flavor = 'latex'

local o = vim.o

o.langmap =
  'ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR,ΣS,ΤT,ΘU,ΩV,WW,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj,κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz'
o.list = true
o.listchars = 'eol:\\U000021b5,extends:>,nbsp:~,precedes:<,tab:  ,trail:\\U00002022'
o.showbreak = '\u{21AA} '

o.spelllang = 'el,en'
o.spellsuggest = 'fast'
o.spelloptions = 'camel'

o.clipboard = 'unnamedplus'
if vim.fn.has 'unix' == 1 then
  if vim.fn.executable 'xsel' == 1 and not vim.fn.exists '$WAYLAND_DISPLAY' == 1 then
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
  o.shell = 'pwsh.exe'
  o.shellxquote = ''
  o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
end
if vim.fn.executable 'rg' == 1 then
  o.grepprg = 'rg --vimgrep --smart-case --hidden --color=never --glob !.git'
  o.grepformat = '%f:%l:%c:%m,%f:%l:%m'

  if vim.fn.executable 'fzf' == 1 then
    --- @param file string The pattern to search for.
    --- @return string[] A list of found file paths. Returns an empty list on error.
    function FindFunc(file)
      return vim.fn.systemlist(
        'rg --files --color=never --hidden --glob "!**/.git/*" --glob "!**/build/*" | fzf --filter="' .. file .. '"'
      )
    end
    o.findfunc = 'v:lua.FindFunc'
  end
end

if vim.fn.has 'nvim-0.12' == 1 then
  o.completefuzzycollect = 'keyword'
end

o.path = o.path .. '**'

o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

o.linebreak = true
o.pumheight = 20
o.completeopt = 'menuone,popup,noinsert,fuzzy'

o.diffopt = 'filler,internal,hiddenoff,algorithm:histogram,indent-heuristic,linematch:60,vertical'
o.incsearch = true
o.smartcase = true
o.mouse = 'c'

o.laststatus = 3
o.showmode = true
o.scrolloff = 3
o.sidescrolloff = 3
o.smoothscroll = true
o.cursorlineopt = 'both'
o.cursorline = true
o.cursorcolumn = false
o.number = false
o.relativenumber = true
o.numberwidth = 2
o.ruler = true
o.signcolumn = 'yes'

o.winborder = 'rounded'
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.timeout = true
o.timeoutlen = 400
o.undofile = true
o.updatetime = 500

o.foldcolumn = '1'
o.fillchars = 'fold: ,foldopen:,foldsep: ,foldclose:'
o.foldenable = true
o.foldtext = ''
o.foldlevel = 99
o.foldlevelstart = 99

o.statuscolumn = '%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "" : "") : " " }%l%s'

for _, provider in ipairs { 'node', 'perl', 'python3', 'ruby' } do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end

-- add binaries installed by mason.nvim to path
vim.env.PATH = vim.env.PATH .. (vim.g.is_windows and ';' or ':') .. vim.fn.stdpath 'data' .. '/mason/bin'

-- Neovide config
if vim.g.neovide then
  require 'neovide'
end
