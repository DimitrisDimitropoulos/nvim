local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig = require 'lspconfig'
lspconfig.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = { checkThirdParty = false, maxPreload = 1000, preloadFileSize = 1000 },
      telemetry = { enable = false },
      hint = { enable = true },
      diagnostics = { globals = { 'vim' } },
      format = { enable = false },
    },
  },
}
