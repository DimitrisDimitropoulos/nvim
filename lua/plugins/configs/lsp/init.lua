vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function()
    require 'plugins.configs.lsp.maps'
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('AutoFormat', { clear = true }),
      pattern = { '*tex', '*lua', '*py', '*jl', '*json', '*yml', '*rs', '*sh' },
      callback = function() vim.lsp.buf.format() end,
      desc = 'format on save',
    })
    require 'plugins.configs.lsp.diagnostics'
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig = require 'lspconfig'
local servers = { 'julials', 'pyright', 'bashls', 'neocmake', 'clangd', 'jsonls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup { capabilities = capabilities }
end
require 'plugins.configs.lsp.texlab'
require 'plugins.configs.lsp.rust_analyzer'
require 'plugins.configs.lsp.efm'
require 'plugins.configs.lsp.lua_ls'

--

--
-- -- Register linters and formatters per language
-- local beautysh = require 'efmls-configs.formatters.beautysh'
-- local cppcheck = require 'efmls-configs.linters.cppcheck'
-- local fourmolu = require 'efmls-configs.formatters.fourmolu'
-- local gersemi = require 'efmls-configs.formatters.gersemi'
-- local stylua = require 'efmls-configs.formatters.stylua'
-- local languages = {
--   lua = { stylua },
--   sh = { beautysh },
--   cmake = { gersemi },
--   haskell = { fourmolu },
--   cpp = { cppcheck },
-- }
--
-- -- Or use the defaults provided by this plugin
-- -- check doc/SUPPORTED_LIST.md for the supported languages
-- --
-- -- local languages = require('efmls-configs.defaults').languages()
--
-- local efmls_config = {
--   filetypes = vim.tbl_keys(languages),
--   settings = {
--     rootMarkers = { '.git/' },
--     languages = languages,
--   },
--   init_options = {
--     documentFormatting = true,
--     documentRangeFormatting = true,
--   },
-- }
--
-- require('lspconfig').efm.setup(vim.tbl_extend('force', efmls_config, {
--   capabilities = capabilities,
-- }))
