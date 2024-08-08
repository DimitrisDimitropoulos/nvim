vim.diagnostic.config {
  underline = true,
  virtual_text = { prefix = '\u{1F5D9}' },
  signs = {
    text = {
      [vim.diagnostic.severity.HINT] = '\u{25A1}',
      [vim.diagnostic.severity.ERROR] = '\u{25A0}',
      [vim.diagnostic.severity.INFO] = '\u{25CF}',
      [vim.diagnostic.severity.WARN] = '\u{25B3}',
    },
  },
  update_in_insert = false,
  float = { source = 'always', border = vim.g.border_style },
  jump = { float = true },
}
