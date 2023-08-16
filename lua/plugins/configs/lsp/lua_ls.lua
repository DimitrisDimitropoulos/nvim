local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig = require 'lspconfig'
lspconfig.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      hint = { enable = true }, -- only for nvim 10.0
      diagnostics = {
        globals = { 'vim' },
      },
      format = {
        -- if enabled will ruin the diagnostics, because it confuses it self,
        -- use it only for tables, until stylua get that functionality
        enable = false,
      },
    },
  },
}
