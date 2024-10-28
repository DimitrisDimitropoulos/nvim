local map = vim.keymap.set
local lsp = vim.lsp.buf

if vim.version().minor < 11 then
  map('n', 'grr', lsp.references, { desc = 'lsp references' })
  map('n', 'gri', lsp.implementation, { desc = 'lsp implementation' })
  map('n', 'grn', lsp.rename, { desc = 'lsp rename' })
  map('n', 'gra', lsp.code_action, { desc = 'lsp code actions', silent = true })
  map('i', '<C-s>', lsp.signature_help, { desc = 'lsp signature help' })
end
map('n', '<leader>lh', function()
  if vim.lsp.inlay_hint.is_enabled() then
    vim.lsp.inlay_hint.enable(false)
  else
    vim.lsp.inlay_hint.enable(true)
  end
end, { desc = 'lsp toggle inlay hints' })
map('n', '<leader>lf', function()
  lsp.format { async = true }
  vim.notify('The buffer has been formatted', vim.log.levels.INFO)
end, { desc = 'lsp async format' })

map('n', 'grd', lsp.declaration, { desc = 'lsp declaration' })
map('n', 'grt', lsp.type_definition, { desc = 'lsp type definition' })

for _, diag in ipairs {
  { key = 'ds', cmd = 'show' },
  { key = 'dh', cmd = 'hide' },
  { key = 'dq', cmd = 'setqflist' },
  { key = 'dl', cmd = 'setloclist' },
} do
  map('n', '<leader>' .. diag.key, vim.diagnostic[diag.cmd], { desc = 'diagnostics ' .. diag.cmd:gsub('_', ' ') })
end
