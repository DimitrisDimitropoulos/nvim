local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_ok then
  return
end
return {
  lspconfig.rust_analyzer.setup {
    capabilities = capabilities,
    settings = {
      ['rust-analyzer'] = { checkOnSave = {
        command = 'clippy',
      } },
    },
  },
}
