vim.diagnostic.config {
  underline = true,
  virtual_text = { prefix = '➤ ' },
  signs = { text = {
    [vim.diagnostic.severity.HINT]  = "󰨔",
    [vim.diagnostic.severity.ERROR] = "■",
    [vim.diagnostic.severity.INFO]  = "◉",
    [vim.diagnostic.severity.WARN]  = "△",
  } },
  update_in_insert = false,
  float = { source = 'always', border = 'rounded', show_header = true },
}
