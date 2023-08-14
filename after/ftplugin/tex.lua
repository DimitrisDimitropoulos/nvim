-- LaTeX options
local g = vim.g
-- VimTeX options
g.vimtex_quickfix_mode = 0
g.vimtex_syntax_enabled = 0
g.vimtex_complete_enabled = 0
g.Tex_BibtexFlavor = "biber"
g.vimtex_view_method = "zathura"
g.latex_view_general_viewer = "zathura"
g.vimtex_compiler_progname = "nvr"
g.tex_flavor = "latex"

vim.opt.cursorlineopt = "number"
vim.opt_local.spell = true

-- Disable TreeSitter highlighting for large files
-- function Disable_tree_sitter_highlight()
--   local line_limit = 900
--   local bufnr = vim.api.nvim_get_current_buf()
--   local line_count = vim.api.nvim_buf_line_count(bufnr)
--   if line_count > line_limit then vim.treesitter.stop() end
-- end
--
-- -- Disable TreeSitter highlighting for large files
-- vim.api.nvim_create_autocmd("Filetype", {
--   pattern = "tex",
--   callback = function() Disable_tree_sitter_highlight() end,
--   desc = "disable tree sitter",
-- })
-- vim.keymap.set("n", "<leader>tx", Disable_tree_sitter_highlight, { desc = "disable treesitter" })

local vimtex_keymap = {
  { key = "ll", cmd = "Compile",   decr = "compile" },
  { key = "to", cmd = "TocToggle", decr = "toggle table of contents" },
  { key = "lv", cmd = "View",      decr = "synctex" },
  { key = "lr", cmd = "Errors",    decr = "errors" },
}
for _, vitex in ipairs(vimtex_keymap) do
  vim.keymap.set("n", "<leader>" .. vitex.key, function() vim.cmd("Vimtex" .. vitex.cmd) end, { desc = vitex.decr })
end

-- map up and down to gj and gk
local function moving_wrap(direction) return (vim.v.count == 0) and "g" .. direction or direction end
vim.keymap.set({ "n", "x" }, "<Up>", function() return moving_wrap "k" end, { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", function() return moving_wrap "j" end, { expr = true, silent = true })
-- function() return (vim.v.count == 0) and "gj" or "j" end,
