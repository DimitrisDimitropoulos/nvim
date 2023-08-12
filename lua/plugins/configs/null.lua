local present, null_ls = pcall(require, "null-ls")
-- local helpers = require("null-ls.helpers")
if not present then return end
-- local format = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local bins = {
  -- FIXME: pending replacment coulduse nvim-lint, @2023-08-12 23:48:11
  diagnostics.cppcheck, -- pending
  -- diagnostics.jsonlint, -- json_lsp
  -- diagnostics.flake8, -- ruff-lsp
}
null_ls.setup { debug = true, sources = bins }
