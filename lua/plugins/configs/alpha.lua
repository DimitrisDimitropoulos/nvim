local alpha_ok, alpha = pcall(require, "alpha")
if not alpha_ok then return end
local dashboard = require "alpha.themes.dashboard"

dashboard.section.header.opts = {
  -- hl = "Comment",
  hl = "PeanutHLGroup",
  position = "center",
}

dashboard.section.header.val = {
  -- "                                                     ",

  -- "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  -- "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  -- "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  -- "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  -- "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  -- "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",

  " _  _  _  _  ____  ____  ____ ",
  "( \\( )( \\/ )(  _ \\(  _ \\( ___)",
  " )  (  \\  /  )___/ )(_) ))__) ",
  "(_)\\_)  \\/  (__)  (____/(____)",
  "                              ",
  "  ~ brain.exist() == null; ~   ",

  -- "                                       ",
  -- "███╗  ██╗██╗   ██╗██████╗ ██████╗ ███████╗",
  -- "████╗ ██║██║   ██║██╔══██╗██╔══██╗██╔════╝",
  -- "██╔██╗██║╚██╗ ██╔╝██████╔╝██║  ██║█████╗  ",
  -- "██║╚████║ ╚████╔╝ ██╔═══╝ ██║  ██║██╔══╝  ",
  -- "██║ ╚███║  ╚██╔╝  ██║     ██████╔╝███████╗",
  -- "╚═╝  ╚══╝   ╚═╝   ╚═╝     ╚═════╝ ╚══════╝",

  -- "        ~ brain.exist() == null; ~        ",
}

dashboard.section.buttons.val = {
  -- { type = "text", val = "~ brain.exist() == NULL; ~", opts = { hl = "Comment", position = "center" } },
  dashboard.button("e", "󰈔  > New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("f", "󰈞  > Find file", ":Telescope fd<CR>"),
  dashboard.button("l", "󱉶  > Live grep", ":Telescope live_grep<CR>"),
  dashboard.button("r", "󰙰  > Recent", ":Telescope oldfiles<CR>"),
  dashboard.button("m", "  > Marks  ", ":Telescope marks<CR>"),
  dashboard.button("L", "󰒲  > Lazy ", ":Lazy<CR>"),
  dashboard.button("M", "󱌢  > Mason ", ":Mason<CR>"),
  dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | wincmd k | Telescope find_files<CR>"),
  dashboard.button("q", "󰩈  > Quit NVIM", ":qa<CR>"),
}

dashboard.section.footer.opts = {
  -- hl = "Function",
  hl = "VioletHLGroup",
  position = "center",
}

local function footer()
  local stats = require("lazy").stats()
  local datetime = os.date "  %m-%d-%Y   %H:%M:%S"
  local version = vim.version()
  local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
  return datetime .. "  ⚡Plugins " .. stats.count .. nvim_version_info
end

dashboard.section.footer.val = footer()

alpha.setup(dashboard.opts)

vim.api.nvim_set_hl(0, "VioletHLGroup", { fg = "#d4bfff" })
vim.api.nvim_set_hl(0, "PeanutHLGroup", { fg = "#ffd899" })
