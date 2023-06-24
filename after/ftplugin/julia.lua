vim.api.nvim_create_augroup("AutoFormatting", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.jl",
  group = "AutoFormatting",
  callback = function()
    vim.lsp.buf.format { async = true }
  end,
  desc = "format on save",
})
local keymapp = vim.keymap.set
local opts = { noremap = true, silent = false }
keymapp("n", "<leader>tr", "<cmd> TroubleToggle <CR>", { desc = "diagnotics" }, opts)
