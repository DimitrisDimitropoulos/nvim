-- LaTeX options

vim.keymap.set("n", "<leader>tr", "")
vim.opt.cursorlineopt = "number"

-- Disable TreeSitter highlighting for large files
function Disable_tree_sitter_highlight()
  local line_limit = 900
  local bufnr = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if line_count > line_limit then
    vim.treesitter.stop()
  end
end

-- Disable TreeSitter highlighting for large files
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "tex",
  callback = function()
    Disable_tree_sitter_highlight()
  end,
  desc = "disable tree sitter",
})

-- vim.keymap.set

local vimtex_keymap = {
  { key = "ll", cmd = "Compile",   decr = "compile" },
  { key = "to", cmd = "TocToggle", decr = "toggle table of contents" },
  { key = "lv", cmd = "View",      decr = "synctex" },
  { key = "lr", cmd = "Errors",    decr = "errors" },
}
for _, vitex in ipairs(vimtex_keymap) do
  vim.keymap.set("n", "<leader>" .. vitex.key, function()
    vim.cmd("Vimtex" .. vitex.cmd)
  end, { desc = vitex.decr })
end

vim.keymap.set(
  "n",
  "<leader>tx",
  Disable_tree_sitter_highlight,
  { desc = "disable treesitter" }
)

-- map up and down to gj and gk
vim.keymap.set("n", "<Up>", function()
  return (vim.v.count == 0) and "gk" or "k"
end, { expr = true, desc = "up", silent = true })
vim.keymap.set("n", "<Down>", function()
  return (vim.v.count == 0) and "gj" or "j"
end, { expr = true, desc = "down", silent = true })
