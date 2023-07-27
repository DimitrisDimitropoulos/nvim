local alpha = require "alpha"
local dashboard = require "alpha.themes.dashboard"

vim.api.nvim_set_hl(0, "PeanutHLGroup", { fg = "#ffd899" })
vim.api.nvim_set_hl(0, "VioletHLGroup", { fg = "#d4bfff" })
-- vim.cmd "highlight PeanutHLGroup guifg=#ffd899"

dashboard.section.header.opts = {
  hl = "Comment",
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
  -- "                                                     ",
  -- "                              ",
  -- " _  _  _  _  ____  ____  ____ ",
  -- "( \\( )( \\/ )(  _ \\(  _ \\( ___)",
  -- " )  (  \\  /  )___/ )(_) ))__) ",
  -- "(_)\\_)  \\/  (__)  (____/(____)",
  -- "                              ",
  -- "  ~ brain.exist() == null; ~   ",
  --
  -- "                                       ",
  "███╗  ██╗██╗   ██╗██████╗ ██████╗ ███████╗",
  "████╗ ██║██║   ██║██╔══██╗██╔══██╗██╔════╝",
  "██╔██╗██║╚██╗ ██╔╝██████╔╝██║  ██║█████╗  ",
  "██║╚████║ ╚████╔╝ ██╔═══╝ ██║  ██║██╔══╝  ",
  "██║ ╚███║  ╚██╔╝  ██║     ██████╔╝███████╗",
  "╚═╝  ╚══╝   ╚═╝   ╚═╝     ╚═════╝ ╚══════╝",
  "        ~ brain.exist() == null; ~         ",
}

dashboard.section.buttons.opts.hl = "Comment"

dashboard.section.buttons.val = {
  -- { type = "text", val = "~ brain.exist() == NULL; ~", opts = { hl = "String", position = "center" } },
  dashboard.button(
    "<space>ee",
    "󰈔  > New file",
    ":ene <BAR> startinsert <CR>"
  ),
  dashboard.button("<space>ff", "󰈞  > Find file", ":Telescope fd<CR>"),
  -- dashboard.button(
  --   "<space>ff",
  --   "󰈞  > Find file",
  --   function() require("telescope.builtin").fd() end
  -- ),
  dashboard.button(
    "<space>lg",
    "󱉶  > Live grep",
    ":Telescope live_grep<CR>"
  ),
  dashboard.button("<space>fr", "󰙰  > Recent", ":Telescope oldfiles<CR>"),
  dashboard.button("<space>fm", "  > Marks  ", ":Telescope marks<CR>"),
  dashboard.button("L", "󰒲  > Lazy ", ":Lazy<CR>"),
  dashboard.button("M", "󱌢  > Mason ", ":Mason<CR>"),
  dashboard.button(
    "s",
    "  > Settings",
    ":e $MYVIMRC | :cd %:p:h | wincmd k | pwd | Telescope find_files<CR>"
  ),
  dashboard.button("q", "󰩈  > Quit NVIM", ":qa<CR>"),
}

dashboard.section.footer.opts = {
  hl = "Function",
  position = "center",
}

local function footer()
  local stats = require("lazy").stats()
  local datetime = os.date "  %m-%d-%Y   %H:%M:%S"
  local version = vim.version()
  local nvim_version_info = "    v"
      .. version.major
      .. "."
      .. version.minor
      .. "."
      .. version.patch
  return datetime .. "  ⚡Plugins " .. stats.count .. nvim_version_info
end

dashboard.section.footer.val = footer()

alpha.setup(dashboard.opts)
