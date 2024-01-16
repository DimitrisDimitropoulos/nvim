vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function()
    local lsp_utils = { 'diagnostics', 'maps', 'format' }
    for _, lsp in ipairs(lsp_utils) do
      require('plugins.configs.lsp.' .. lsp)
    end
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig = require 'lspconfig'
local servers = { 'julials', 'bashls', 'neocmake', 'clangd', 'pylyzer' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup { capabilities = capabilities }
end
local custom_servers = { 'texlab', 'rust_analyzer', 'efm', 'lua_ls' }
for _, lsp in ipairs(custom_servers) do
  require('plugins.configs.lsp.' .. lsp)
end
