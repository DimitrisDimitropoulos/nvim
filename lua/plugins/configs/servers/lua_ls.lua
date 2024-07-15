local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_ok then
  return
end

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
