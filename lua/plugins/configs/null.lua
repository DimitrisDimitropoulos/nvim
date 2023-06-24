local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local format = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {
  sources = {
    format.stylua, -- for lua
    diagnostics.selene,
    format.prettierd, -- for web dev
  },
}
