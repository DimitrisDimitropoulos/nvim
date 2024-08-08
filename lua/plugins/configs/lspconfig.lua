require('lspconfig.ui.windows').default_options.border = vim.g.border_style
local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig = require 'lspconfig'
local servers = { 'julials', 'bashls', 'neocmake', 'clangd', 'ruff', 'taplo', 'typst_lsp' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup { capabilities = capabilities }
end
local custom_servers = { 'texlab', 'rust_analyzer', 'efm', 'lua_ls' }
for _, lsp in ipairs(custom_servers) do
  require('plugins.configs.servers.' .. lsp)
end
