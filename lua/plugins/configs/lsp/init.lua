vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function()
    require "plugins.configs.lsp.maps"
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("AutoFormat", { clear = true }),
      pattern = { "*tex", "*lua", "*py", "*jl", "*json", "*yml", "*rs", "*sh" },
      callback = function()
        vim.lsp.buf.format()
        -- vim.diagnostic.show()
      end,
      desc = "format on save",
    })
    require "plugins.configs.lsp.diagnostics"
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig = require "lspconfig"
local servers = { "julials", "pyright", "bashls", "neocmake", "clangd", "ruff_lsp", "jsonls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup { capabilities = capabilities }
end
require "plugins.configs.lsp.texlab"
require "plugins.configs.lsp.rust_analyzer"
require "plugins.configs.lsp.efm"
require "plugins.configs.lsp.lua_ls"
