local options = {
  icons = {
    breadcrumb = "»",
    separator = "  ",
    group = "+",
  },
  popup_mappings = {
    scroll_down = "<c-d>",
    scroll_up = "<c-u>",
  },
  window = {
    -- none/single/double/shadow
    border = "none",
  },
  layout = {
    spacing = 8,
  },
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    n = { "j", "k", "d", "c", "y", "h", "l", "f", "F", "t", "T" },
    i = { "j", "k", "d", "c", "y", "h", "l", "f", "F", "t", "T" },
    x = { "j", "k", "d", "c", "y", "h", "l", "f", "F", "t", "T" },
  },
}

return options
