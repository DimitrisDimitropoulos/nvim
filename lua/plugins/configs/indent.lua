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

local ui_utils = require "utils.ui_utils"
-- Set the hightlight group
vim.api.nvim_set_hl(
  0,
  "IndentBlanklineContextStart",
  -- { bg = "#3D3834", bold = true }
  { bg = tostring(ui_utils.get_hl("Visual").background), bold = true }
)

--
-- local function get_hl(name)
--   local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
--   if not ok then return end
--   for _, key in pairs { "foreground", "background", "special" } do
--     if hl[key] then hl[key] = string.format("#%06x", hl[key]) end
--   end
--   return hl
-- end
--
-- -- Set the hightlight group
-- vim.api.nvim_set_hl(
--   0,
--   "IndentBlanklineContextStart",
--   -- { bg = "#3D3834", bold = true }
--   { bg = tostring(get_hl("Visual").background), bold = true }
-- )
--
-- vim.api.nvim_set_hl(0, "@lsp.type.parameter", { italic = true, fg = "#d4bfff" })
--
-- -- hl groups for the comments
-- -- NOTE: Treesitter is prone to breaking changes, @2023-07-24 17:05:41
-- local comms_hl = { "@text.todo", "@text.danger", "@text.warning", "@text.note" }
-- for _, hl in ipairs(comms_hl) do
--   vim.api.nvim_set_hl(0, hl, { bold = true, underline = true })
-- end
