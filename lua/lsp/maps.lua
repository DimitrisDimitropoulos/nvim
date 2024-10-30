local map = vim.keymap.set

if vim.version().minor < 11 then
  map('n', 'grr', vim.lsp.buf.references, { desc = 'lsp references' })
  map('n', 'gri', vim.lsp.buf.implementation, { desc = 'lsp implementation' })
  map('n', 'grn', vim.lsp.buf.rename, { desc = 'lsp rename' })
  map('n', 'gra', vim.lsp.buf.code_action, { desc = 'lsp code actions', silent = true })
  map('i', '<C-s>', vim.lsp.buf.signature_help, { desc = 'lsp signature help' })
end
map('n', '<leader>lh', function()
  if vim.lsp.inlay_hint.is_enabled() then
    vim.lsp.inlay_hint.enable(false)
  else
    vim.lsp.inlay_hint.enable(true)
  end
end, { desc = 'lsp toggle inlay hints' })
map('n', '<leader>lf', function()
  vim.lsp.buf.format { async = true }
  vim.notify('The buffer has been formatted', vim.log.levels.INFO)
end, { desc = 'lsp async format' })

map('n', 'grd', vim.lsp.buf.declaration, { desc = 'lsp declaration' })
map('n', 'grt', vim.lsp.buf.type_definition, { desc = 'lsp type definition' })

map('n', '<leader>ds', vim.diagnostic.show, { desc = 'diagnostics show' })
map('n', '<leader>dh', vim.diagnostic.hide, { desc = 'diagnostics hide' })
map('n', '<leader>dq', vim.diagnostic.setqflist, { desc = 'diagnostics setqflist' })
map('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'diagnostics setloclist' })
