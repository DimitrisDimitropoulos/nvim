require('lspconfig').tinymist.setup {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  single_file_support = true,
  settings = {
    exportPdf = 'onSave',
    formatterMode = 'typstyle',
    -- typstExtraArgs = { '--pdf-standard=a-2b' },
  },
}
