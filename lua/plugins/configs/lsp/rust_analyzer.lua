local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig = require 'lspconfig'
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
