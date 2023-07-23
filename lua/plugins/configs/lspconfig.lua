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
    keymapp(n, "<S-k>", lsp.hover, { desc = "hover" }, opts)
    keymapp(n, "<leader>qf", lsp.code_action, { desc = "code actions" }, { silent = true })
    keymapp(n, "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { desc = "list workspace folders" }, opts)
    keymapp(n, "<A-f>", function()
      vim.lsp.buf.format { async = true }
    end, { desc = "format code" }, opts)

    local lsp_mappings = {
      { key = "gd", cmd = "definition",              desc = "go to definition" },
      { key = "gD", cmd = "declaration",             desc = "go to declaration" },
      { key = "gi", cmd = "implementation",          desc = "go to implementation" },
      { key = "ln", cmd = "rename",                  desc = "rename" },
      { key = "kk", cmd = "signature_help",          desc = "signature" },
      { key = "gr", cmd = "references",              desc = "references" },
      { key = "gh", cmd = "type_definition",         desc = "type definition" },
      { key = "wa", cmd = "add_workspace_folder",    desc = "add workspace folder" },
      { key = "wr", cmd = "remove_workspace_folder", desc = "remove workspace folder" },
    }

    for _, mapping in ipairs(lsp_mappings) do
      keymapp(n, "<leader>" .. mapping.key, lsp[mapping.cmd], { desc = mapping.desc }, opts)
    end
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
local lspconfig = require "lspconfig"

-- setup multiple servers with same default options
local servers = {
  "texlab",
  -- "ltex",
  "julials",
  "pyright",
  "bashls",
  "neocmake",
}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}

lspconfig.clangd.setup {
  capabilities = capabilities,
  cmd = { "clangd", "--background-index", "--clang-tidy" },
}

lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  },
}
