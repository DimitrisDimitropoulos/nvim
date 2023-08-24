local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig = require 'lspconfig'

return {
  -- NOTE: with the following config it can replace null-ls and vimtex, @2023-08-11 15:29:27
  lspconfig.texlab.setup {
    capabilities = capabilities,
    settings = {
      texlab = {
        build = {
          -- onSave = true,
          args = {
            '-pdf',
            '-lualatex',
            '-interaction=nonstopmode',
            '-synctex=1',
            '%f',
          },
        },
        forwardSearch = {
          executable = 'zathura',
          args = { '--synctex-forward', '%l:1:%f', '%p' },
        },
        chktex = {
          onOpenAndSave = true,
          onEdit = false,
        },
        diagnosticsDelay = 200,
        latexFormatter = 'latexindent',
        latexindent = {
          ['local'] = nil, -- local is a reserved keyword
          modifyLineBreaks = false,
        },
        bibtexFormatter = 'texlab',
        formatterLineLength = 80,
      },
    },
  },
}
