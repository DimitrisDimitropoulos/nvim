local alpha_ok, alpha = pcall(require, 'alpha')
if not alpha_ok then return end
local dashboard = require 'alpha.themes.dashboard'

dashboard.section.header.opts = {
  hl = 'String',
  position = 'center',
}

dashboard.section.header.val = {
  -- "                                                     ",

  -- [[  /\ \▔\___  ___/\   /(O)_ __ ___  ]],
  -- [[ /  \/ / _ \/ _ \ \ / / | '_ ` _ \ ]],
  -- [[/ /\  /  __/ (_) \ V /| | | | | | |]],
  -- [[\_\ \/ \___|\___/ \_/ |_|_| |_| |_|]],
  -- [[───────────────────────────────────]],

  ' ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
  ' ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
  ' ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
  ' ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
  ' ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
  ' ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
  '             ~ brain.exist() == null; ~             ',

  -- '⡏⠉⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿',
  -- '⣿⠀⠀⠀⠈⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⠁⠀⣿',
  -- '⣿⣧⡀⠀⠀⠀⠀⠙⠿⠿⠿⠻⠿⠿⠟⠿⠛⠉⠀⠀⠀⠀⠀⣸⣿',
  -- '⣿⣿⣷⣄⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿',
  -- '⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣴⣿⣿⣿⣿',
  -- '⣿⣿⣿⡟⠀⠀⢰⣹⡆⠀⠀⠀⠀⠀⠀⣭⣷⠀⠀⠀⠸⣿⣿⣿⣿',
  -- '⣿⣿⣿⠃⠀⠀⠈⠉⠀⠀⠤⠄⠀⠀⠀⠉⠁⠀⠀⠀⠀⢿⣿⣿⣿',
  -- '⣿⣿⣿⢾⣿⣷⠀⠀⠀⠀⡠⠤⢄⠀⠀⠀⠠⣿⣿⣷⠀⢸⣿⣿⣿',
  -- '⣿⣿⣿⡀⠉⠀⠀⠀⠀⠀⢄⠀⢀⠀⠀⠀⠀⠉⠉⠁⠀⠀⣿⣿⣿',
  -- '⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿',
  -- '⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿',
  -- -- '~ brain.exist() == null ~',

  --
}

dashboard.section.buttons.val = {
  -- { type = "text", val = "~ brain.exist() == NULL; ~", opts = { hl = "Comment", position = "center" } },
  dashboard.button('r', '󰙰  > Oldfiles', ':Telescope oldfiles<CR>'),
  dashboard.button('f', '󰈞  > Find File', ':Telescope fd<CR>'),
  dashboard.button('l', '󱉶  > Live Grep', ':Telescope live_grep<CR>'),
  dashboard.button('b', '  > Browse', ':Telescope file_browser initial_mode=normal <CR>'),
  dashboard.button('m', '  > Marks', ':Telescope marks<CR>'),
  dashboard.button('L', '󰒲  > Lazy ', ':Lazy<CR>'),
  dashboard.button('M', '󱌢  > Mason ', ':Mason<CR>'),
  -- dashboard.button('s', '  > Settings', ':e $MYVIMRC | :cd %:p:h | Telescope file_browser initial_mode=normal <CR>'),
  -- dashboard.button('s', '  > Settings', ':cd ~/.config/nvim | Telescope file_browser initial_mode=normal <CR>'),
  dashboard.button('q', '󰩈  > Quit NVIM', ':qa<CR>'),
}

dashboard.section.footer.opts = {
  hl = 'PeanutHLGroup',
  position = 'center',
}

local function footer()
  local stats = require('lazy').stats()
  -- local datetime = os.date '  %m-%d-%Y   %H:%M:%S'
  local version = vim.version()
  local nvim_version_info = '    v' .. version.major .. '.' .. version.minor .. '.' .. version.patch
  -- return datetime .. ' ⚡' .. stats.count .. ' plugins' .. nvim_version_info
  return '  ⚡Plugins ' .. stats.count .. nvim_version_info
end

dashboard.section.footer.val = footer()

vim.opt_local.fillchars = { eob = ' ' }

alpha.setup(dashboard.opts)

vim.api.nvim_set_hl(0, 'VioletHLGroup', { fg = '#d4bfff' })
vim.api.nvim_set_hl(0, 'PeanutHLGroup', { fg = '#ffd899' })
