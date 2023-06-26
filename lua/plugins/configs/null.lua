local present, null_ls = pcall(require, "null-ls")
local helpers = require("null-ls.helpers")

if not present then
  return
end

local format = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local bins = {

  -- Lua
  format.stylua,
  diagnostics.selene,

  -- Cpp
  diagnostics.cppcheck,
  diagnostics.gccdiag,

  -- WebDev
  format.prettierd,
  diagnostics.jsonlint,

  -- LaTex
  diagnostics.chktex,
  format.latexindent,

  --shell
  diagnostics.shellcheck,
  format.beautysh,

  -- rust
  format.rustfmt,

  -- python
  format.black,
  diagnostics.flake8,

  -- haskell
  format.fourmolu,
}

helpers.generator_factory({
  multiple_files = true,
})

null_ls.setup({
  debug = true,
  sources = bins,
})
