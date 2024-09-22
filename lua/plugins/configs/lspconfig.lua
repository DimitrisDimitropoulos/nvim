-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local map = vim.keymap.set
    local lsp = vim.lsp.buf
    local opts = { buffer = ev.buf, silent = false }
    local n = "n"

    map(n, "<A-f>", lsp.format, { desc = "format code" }, opts)
    map(n, "<S-k>", lsp.hover, { desc = "hover" }, opts)
    map(
      n,
      "<leader>qf",
      lsp.code_action,
      { desc = "code actions" },
      { silent = true }
    )
    map(
      n,
      "<space>wl",
      function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
      { desc = "list workspace folders" },
      opts
    )
    map(
      n,
      "<A-f>",
      function() vim.lsp.buf.format { async = true } end,
      { desc = "format code" },
      opts
    )

    local lsp_mappings = {
      {
        key = "gd",
        cmd = "definition",
        desc = "go to definition",
      },
      {
        key = "gD",
        cmd = "declaration",
        desc = "go to declaration",
      },
      {
        key = "gi",
        cmd = "implementation",
        desc = "go to implementation",
      },
      { key = "ln", cmd = "rename",          desc = "rename" },
      { key = "kk", cmd = "signature_help",  desc = "signature" },
      { key = "gr", cmd = "references",      desc = "references" },
      { key = "gh", cmd = "type_definition", desc = "type definition" },
      {
        key = "wa",
        cmd = "add_workspace_folder",
        desc = "add workspace folder",
      },
      {
        key = "wr",
        cmd = "remove_workspace_folder",
        desc = "remove workspace folder",
      },
    }

    for _, mapping in ipairs(lsp_mappings) do
      map(
        n,
        "<leader>" .. mapping.key,
        lsp[mapping.cmd],
        { desc = mapping.desc },
        opts
      )
    end

    local diagno = {
      { key = "<leader>df", cmd = "open_float", descr = "diagnostics float" },
      { key = "[d",         cmd = "goto_prev",  descr = "diagnostics prev" },
      { key = "]d",         cmd = "goto_next",  descr = "diagnostics next" },
    }
    for _, diag in ipairs(diagno) do
      map(n, diag.key, vim.diagnostic[diag.cmd], { desc = diag.descr }, opts)
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
  "clangd",
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
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
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
