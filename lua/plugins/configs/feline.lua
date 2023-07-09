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
  peanut = "#f6d5a4",
}

local vi_mode_colors = {
  NORMAL = "peanut",
  OP = "green",
  INSERT = "yellow",
  VISUAL = "purple",
  LINES = "orange",
  BLOCK = "dark_red",
  REPLACE = "red",
  COMMAND = "green",
}

local lsp_progress = function()
  local lsp = vim.lsp.util.get_progress_messages()[1]
  if lsp then
    local name = lsp.name or ""
    local msg = lsp.message or ""
    local title = lsp.title or ""
    return string.format(" %%<%s: %s %s ", name, title, msg)
  end
  return ""
end

local cproviders = {
  lsp_progress = function()
    return #vim.lsp.buf_get_clients() > 0 and lsp_progress() or ""
  end,
}

local c = {
  vim_mode = {
    icon = "",
    provider = {
      name = "vi_mode",
      opts = {
        show_mode_name = true,
        -- padding = "center", -- Uncomment for extra padding.
      },
    },
    priority = 10, -- Necessary to appear while truncated
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
    },
    left_sep = "block",
    right_sep = "block",
  },
  gitDiffAdded = {
    provider = "git_diff_added",
    hl = {
      fg = "green",
      bg = "darkblue",
      truncate_hide = true,
    },
    left_sep = "block",
    right_sep = "block",
    truncate_hide = true,
  },
  gitDiffRemoved = {
    provider = "git_diff_removed",
    hl = {
      fg = "red",
      bg = "darkblue",
    },
    left_sep = "block",
    right_sep = "block",
    truncate_hide = true,
  },
  gitDiffChanged = {
    provider = "git_diff_changed",
    hl = {
      fg = "fg",
      bg = "darkblue",
    },
    left_sep = "block",
    right_sep = "right_filled",
    truncate_hide = true,
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
      style = "italic",
    },
    left_sep = " ",
    right_sep = " ",
  },
  diagnostic_errors = {
    provider = "diagnostic_errors",
    hl = {
      fg = "red",
      style = "bold",
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
    truncate_hide = true,
  },
  diagnostic_info = {
    provider = "diagnostic_info",
    truncate_hide = true,
  },
  lsp_client_names = {
    provider = "lsp_client_names",
    hl = {
      fg = "violet",
      bg = "darkblue",
    },
    left_sep = "left_filled",
    right_sep = "block",
    truncate_hide = true,
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
      fg = "peanut",
      bg = "darkblue",
    },
    left_sep = "block",
    right_sep = "block",
    truncate_hide = true,
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
    truncate_hide = true,
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
    truncate_hide = true,
  },
  line_percentage = {
    provider = "line_percentage",
    hl = {
      fg = "violet",
      bg = "darkblue",
      style = "bold",
    },
    left_sep = "block",
    right_sep = "block",
    truncate_hide = true,
  },
  scroll_bar = {
    provider = "scroll_bar",
    hl = {
      fg = "yellow",
      style = "bold",
    },
  },
  lsp_progress = {
    provider = "lsp_progress",
    hl = {
      fg = "green",
      style = "italic",
    },
    left_sep = "block",
    right_sep = "block",
    truncate_hide = true,
  },
}

local middle = {
  c.lsp_progress,
}

local right = {
  c.lsp_client_names,
  c.file_type,
  c.file_encoding,
  c.position,
  -- c.line_percentage,
  -- c.scroll_bar,
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
  custom_providers = cproviders,
})
