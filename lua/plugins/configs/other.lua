require("indent_blankline").setup {
  indentLine_enabled = 1,
  filetype_exclude = {
    "help",
    "terminal",
    "lazy",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "mason",
    "alpha",
    "",
  },
  buftype_exclude = { "terminal" },
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  show_current_context = true,
  show_current_context_start = true,
  indent_blankline_use_treesitter = true,
}
-- Set the hightlight group
vim.api.nvim_set_hl(
  0,
  "IndentBlanklineContextStart",
  { bg = "#3D3834", bold = true }
)

vim.api.nvim_set_hl(0, "@lsp.type.parameter", { italic = true })

-- hl groups for the comments
-- NOTE: Treesitter is prone to breaking changes, @2023-07-24 17:05:41
local comms_hl = { "@text.todo", "@text.danger", "@text.warning", "@text.note" }
for _, hl in ipairs(comms_hl) do
  vim.api.nvim_set_hl(0, hl, { bold = true, underline = true })
end

-- Mini textobjects
require("mini.ai").setup {
  custom_textobjects = {
    -- Whole buffer textobject
    M = function(ai_type)
      local n_lines = vim.fn.line "$"
      local start_line, end_line = 1, n_lines
      if ai_type == "i" then
        -- Skip first and last blank lines for `i` textobject
        local first_nonblank, last_nonblank =
          vim.fn.nextnonblank(1), vim.fn.prevnonblank(n_lines)
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
}

local mini_plugs = {
  "splitjoin",
  "bracketed",
  "jump",
}
for _, plug in ipairs(mini_plugs) do
  require("mini." .. plug).setup {}
end

require("colorizer").setup {
  filetypes = {
    "css",
    "javascript",
    "lua",
    "ini",
    html = {
      mode = "foreground",
    },
  },
}
