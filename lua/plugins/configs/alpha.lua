local alpha_ok, alpha = pcall(require, 'alpha')
if not alpha_ok then return end
local dashboard = require 'alpha.themes.dashboard'

dashboard.section.header.opts = { hl = 'Comment', position = 'center' }

dashboard.section.header.val = {
  ' ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
  ' ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
  ' ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
  ' ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
  ' ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
  ' ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
  -- '             ~ brain.exist() == null; ~             ',
}

dashboard.section.buttons.val = {
  dashboard.button('r', '󰙰  > Oldfiles', ':Telescope oldfiles<CR>'),
  dashboard.button('f', '󰈞  > Find File', ':Telescope fd<CR>'),
  dashboard.button('l', '󱉶  > Live Grep', ':Telescope live_grep<CR>'),
  dashboard.button('m', '  > Marks', ':Telescope marks<CR>'),
  dashboard.button('L', '󰒲  > Lazy ', ':Lazy<CR>'),
  dashboard.button('M', '󱌢  > Mason ', ':Mason<CR>'),
  dashboard.button('q', '󰩈  > Quit NVIM', ':qa<CR>'),
}

dashboard.section.footer.opts = { hl = 'PeanutHLGroup', position = 'center' }

local function footer()
  local stats = require('lazy').stats()
  local version = vim.version()
  local nvim_version_info = '    v' .. version.major .. '.' .. version.minor .. '.' .. version.patch
  return '  ⚡Plugins ' .. stats.count .. nvim_version_info
end

dashboard.section.footer.val = footer()

vim.opt_local.fillchars = { eob = ' ' }

alpha.setup(dashboard.opts)

vim.api.nvim_set_hl(0, 'VioletHLGroup', { fg = '#d4bfff' })
vim.api.nvim_set_hl(0, 'PeanutHLGroup', { fg = '#ffd899' })
