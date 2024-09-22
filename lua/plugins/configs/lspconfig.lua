-- Global mappings.
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local keymapp = vim.keymap.set
    local lsp = vim.lsp.buf
    local opts = { buffer = ev.buf, silent = false }
    local n = "n"

    keymapp(n, "<A-f>", lsp.format, { desc = "format code" }, opts)
    keymapp(n, "<leader>gd", lsp.definition, { desc = "go to definition" }, opts)
    keymapp(n, "<leader>gD", lsp.declaration, { desc = "go to declaration" }, opts)
    keymapp(n, "<leader>gi", lsp.implementation, { desc = "go to implementation" }, opts)
    keymapp(n, "<leader>ln", lsp.rename, { desc = "rename" }, opts)
    keymapp(n, "<S-k>", lsp.hover, { desc = "hover" }, opts)
    keymapp(n, "<leader>kk", lsp.signature_help, { desc = "signature" }, opts)
    keymapp(n, "<leader>gr", lsp.references, { desc = "references" }, opts)
    keymapp(n, "<leader>gh", lsp.type_definition, { desc = "type definition" }, opts)
    keymapp(n, "<leader>qf", lsp.code_action, { desc = "code actions" }, { silent = true })
    keymapp(n, "<leader>wa", lsp.add_workspace_folder, { desc = "add workspace folder" }, opts)
    keymapp(n, "<leader>wr", lsp.remove_workspace_folder, { desc = "remove workspace folder" }, opts)

    vim.keymap.set(n, "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { desc = "list workspace folders" }, opts)

    vim.keymap.set("n", "<A-f>", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "format code" }, opts)
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}
-- Setup language servers.
local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

-- setup multiple servers with same default options
local servers = {
  "tsserver",
  "html",
  "cssls",
  "texlab",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    capabilities = capabilities,
  })
end

lspconfig.clangd.setup({
  capabilities = capabilities,
  cmd = { "clangd", "--background-index", "--clang-tidy" },
})
