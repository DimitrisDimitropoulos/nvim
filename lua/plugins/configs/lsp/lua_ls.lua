local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig = require "lspconfig"
return {
  lspconfig.lua_ls.setup {
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        hint = { enable = true }, -- only for nvim 10.0
        diagnostics = {
          globals = { "vim" },
          -- disable = { "different-requires" },
        },
        format = {
          enable = true,
        },
      },
    },
  },
}
