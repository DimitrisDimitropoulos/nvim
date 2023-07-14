-- LaTex Options

-- Disable TreeSitter highlighting for large files
function Disable_tree_sitter_highlight()
  local line_limit = 900
  local bufnr = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if line_count > line_limit then
    vim.cmd("TSBufDisable highlight")
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
local keymapp = vim.keymap.set
keymapp("n", "<leader>ll", "<cmd> VimtexCompile <CR>", { desc = "compile" })
keymapp("n", "<leader>to", "<cmd> VimtexTocToggle <CR>", { desc = "toggle table of contents" })
keymapp("n", "<leader>lv", "<cmd> VimtexView <CR>", { desc = "synctex" })
keymapp("n", "<leader>lr", "<cmd> VimtexErrors <CR>", { desc = "errors" })
keymapp("n", "<leader>tx", Disable_tree_sitter_highlight, { desc = "disable treesitter" })
