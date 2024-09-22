vim.api.nvim_create_augroup("AutoFormatting", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.yaml",
  group = "AutoFormatting",
  callback = function()
    vim.lsp.buf.format { async = true }
  end,
  desc = "format on save",
})
