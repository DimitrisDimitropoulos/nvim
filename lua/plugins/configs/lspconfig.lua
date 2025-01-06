for _, lsp in ipairs {
  'julials',
  'bashls',
  'neocmake',
  'clangd',
  'ruff',
  'taplo',
  'yamlls',
  'basedpyright',
  'tinymist',
  'zls',
} do
  require('lspconfig')[lsp].setup { capabilities = vim.lsp.protocol.make_client_capabilities() }
end
for _, lsp in ipairs { 'texlab', 'rust_analyzer', 'efm', 'lua_ls' } do
  require('plugins.configs.servers.' .. lsp)
end
