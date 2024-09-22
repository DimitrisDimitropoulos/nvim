require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
      cancel_installation = "<C-c>",
    },
  },
})

require("indent_blankline").setup({
  indentLine_enabled = 1,
  filetype_exclude = {
    "help",
    "terminal",
    "lazy",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "mason",
    "Alpha",
    "",
  },
  buftype_exclude = { "terminal" },
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  show_current_context = true,
  show_current_context_start = true,
  indent_blankline_use_treesitter = true,
})

-- Mini textobjects
require("mini.ai").setup({
  custom_textobjects = {
    -- Whole buffer textobject
    z = function(ai_type)
      local n_lines = vim.fn.line("$")
      local start_line, end_line = 1, n_lines
      if ai_type == "i" then
        -- Skip first and last blank lines for `i` textobject
        local first_nonblank, last_nonblank = vim.fn.nextnonblank(1), vim.fn.prevnonblank(n_lines)
        start_line = first_nonblank == 0 and 1 or first_nonblank
        end_line = last_nonblank == 0 and n_lines or last_nonblank
      end
      local to_col = math.max(vim.fn.getline(end_line):len(), 1)
      return {
        from = {
          line = start_line,
          col = 1,
        },
        to = {
          line = end_line,
          col = to_col,
        },
      }
    end,
  },
})
-- Mini splitjoins arguments no TS required
require("mini.splitjoin").setup({})
-- Mini bracketed textobjects
require("mini.bracketed").setup({})
-- Mini jump extension to FfTf
require("mini.jump").setup({})

require("colorizer").setup({
  filetypes = {
    "css",
    "javascript",
    "lua",
    html = {
      mode = "foreground",
    },
  },
})
