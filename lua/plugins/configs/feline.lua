local line_ok, feline = pcall(require, "feline")
if not line_ok then
  return
end

local gruvbox = {
  fg = "#ebdbb2",
  bg = "#3c3836",
  black = "#3c3836",
  -- skyblue = "#83a598",
  cyan = "#3c3836",
  green = "#b8bb26",
  oceanblue = "#3c3836",
  blue = "#3c3836",
  darkblue = "#3c3836",
  magenta = "#d3869b",
  orange = "#d65d0e",
  red = "#fb4934",
  violet = "#b16286",
  white = "#ebdbb2",
  yellow = "#fabd2f",
  purple = "#c678dd",
}

--[[ local one_monokai = {
  purple = "#c678dd",
  orange = "#d19a66",
  peanut = "#f6d5a4",
  red = "#e06c75",
  -- aqua = "#61afef",
  darkblue = "#494D64",
  dark_red = "#f75f5f",
  -- "#494D64",
  -- "#ED8796",
  yellow = "#EED49F",
  aqua = "#8AADF4",
  -- "#F5BDE6",
  -- "#8BD5CA",
  -- "#B8C0E0",
  -- /* 8 bright colors */
  -- "#5B6078",
  -- "#ED8796",
  green = "#A6DA95",
  -- "#EED49F",
  -- "#8AADF4",
  -- "#F5BDE6",
  -- "#8BD5CA",
  -- "#A5ADCB",
  -- i want a dark brown
  fg = "#F4DBD6", --[[  default foreground colour  ]]
-- bg = "#f6d5a4",
-- [258] = "#F4DBD6", /*575268*/
-- } ]]

local vi_mode_colors = {
  NORMAL = "green",
  OP = "green",
  INSERT = "yellow",
  VISUAL = "purple",
  LINES = "orange",
  BLOCK = "dark_red",
  REPLACE = "red",
  COMMAND = "aqua",
}

local c = {
  vim_mode = {
    provider = {
      name = "vi_mode",
      opts = {
        show_mode_name = true,
        -- padding = "center", -- Uncomment for extra padding.
      },
    },
    hl = function()
      return {
        fg = require("feline.providers.vi_mode").get_mode_color(),
        bg = "darkblue",
        style = "bold",
        name = "NeovimModeHLColor",
      }
    end,
    left_sep = "block",
    right_sep = "block",
  },
  gitBranch = {
    provider = "git_branch",
    hl = {
      fg = "peanut",
      bg = "darkblue",
      style = "bold",
    },
    left_sep = "block",
    right_sep = "block",
  },
  gitDiffAdded = {
    provider = "git_diff_added",
    hl = {
      fg = "green",
      bg = "darkblue",
    },
    left_sep = "block",
    right_sep = "block",
  },
  gitDiffRemoved = {
    provider = "git_diff_removed",
    hl = {
      fg = "red",
      bg = "darkblue",
    },
    left_sep = "block",
    right_sep = "block",
  },
  gitDiffChanged = {
    provider = "git_diff_changed",
    hl = {
      fg = "fg",
      bg = "darkblue",
    },
    left_sep = "block",
    right_sep = "right_filled",
  },
  separator = {
    provider = "",
  },
  fileinfo = {
    provider = {
      name = "file_info",
      opts = {
        type = "relative-short",
      },
    },
    hl = {
      style = "bold",
    },
    left_sep = " ",
    right_sep = " ",
  },
  diagnostic_errors = {
    provider = "diagnostic_errors",
    hl = {
      fg = "red",
    },
  },
  diagnostic_warnings = {
    provider = "diagnostic_warnings",
    hl = {
      fg = "yellow",
    },
  },
  diagnostic_hints = {
    provider = "diagnostic_hints",
    hl = {
      fg = "aqua",
    },
  },
  diagnostic_info = {
    provider = "diagnostic_info",
  },
  lsp_client_names = {
    provider = "lsp_client_names",
    hl = {
      fg = "purple",
      bg = "darkblue",
      style = "bold",
    },
    left_sep = "left_filled",
    right_sep = "block",
  },
  file_type = {
    provider = {
      name = "file_type",
      opts = {
        filetype_icon = true,
        case = "titlecase",
      },
    },
    hl = {
      fg = "red",
      bg = "darkblue",
      style = "bold",
    },
    left_sep = "block",
    right_sep = "block",
  },
  file_encoding = {
    provider = "file_encoding",
    hl = {
      fg = "orange",
      bg = "darkblue",
      style = "italic",
    },
    left_sep = "block",
    right_sep = "block",
  },
  position = {
    provider = "position",
    hl = {
      fg = "green",
      bg = "darkblue",
      style = "bold",
    },
    left_sep = "block",
    right_sep = "block",
  },
  line_percentage = {
    provider = "line_percentage",
    hl = {
      fg = "aqua",
      bg = "darkblue",
      style = "bold",
    },
    left_sep = "block",
    right_sep = "block",
  },
  scroll_bar = {
    provider = "scroll_bar",
    hl = {
      fg = "yellow",
      style = "bold",
    },
  },
}

local left = {
  c.vim_mode,
  c.fileinfo,
  c.gitBranch,
  c.gitDiffAdded,
  c.gitDiffRemoved,
  c.gitDiffChanged,
  c.diagnostic_errors,
  c.diagnostic_warnings,
  c.diagnostic_info,
  c.diagnostic_hints,
  c.separator,
}

local middle = {}

local right = {
  c.lsp_client_names,
  c.file_type,
  c.file_encoding,
  c.position,
  -- c.line_percentage,
  -- c.scroll_bar,
}

local components = {
  active = {
    left,
    middle,
    right,
  },
  inactive = {
    left,
    middle,
    right,
  },
}

feline.setup({
  components = components,
  theme = gruvbox,
  vi_mode_colors = vi_mode_colors,
})
