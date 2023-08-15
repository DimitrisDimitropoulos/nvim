-- NOTE: here follows the diagnostics config, @2023-08-11 14:35:14
local signs = {
  { hl = "DiagnosticSignError", txt = "■" },
  { hl = "DiagnosticSignWarn", txt = "△" },
  { hl = "DiagnosticSignInfo", txt = "○" },
  { hl = "DiagnosticSignHint", txt = "󰨔" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.hl, { text = sign.txt, texthl = sign.hl })
end

vim.diagnostic.config {
  underline = true,
  virtual_text = {
    prefix = "󰋙",
    -- prefix = "󰄛",
  },
  signs = true,
  update_in_insert = false,
  float = {
    source = "always",
    border = "rounded",
    show_header = true,
  },
}
