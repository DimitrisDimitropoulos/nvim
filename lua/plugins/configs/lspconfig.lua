require('lspconfig.ui.windows').default_options.border = vim.g.border_style
local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig = require 'lspconfig'
for _, lsp in ipairs { 'julials', 'bashls', 'neocmake', 'clangd', 'ruff', 'taplo', 'yamlls', 'basedpyright', 'tinymist' } do
  lspconfig[lsp].setup { capabilities = capabilities }
end
for _, lsp in ipairs { 'texlab', 'rust_analyzer', 'efm', 'lua_ls' } do
  require('plugins.configs.servers.' .. lsp)
end
