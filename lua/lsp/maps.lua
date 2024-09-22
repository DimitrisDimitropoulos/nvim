local map = vim.keymap.set
local lsp = vim.lsp.buf

map('n', 'grr', lsp.references, { desc = 'lsp references' })
map('n', 'grn', lsp.rename, { desc = 'lsp rename' })
map('n', 'gra', lsp.code_action, { desc = 'lsp code actions', silent = true })
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
map('i', '<C-s>', lsp.signature_help, { desc = 'lsp signature help' })

for _, mapping in ipairs {
  { key = 'gi', cmd = 'implementation' },
  { key = 'gd', cmd = 'declaration' },
  { key = 'gh', cmd = 'type_definition' },
} do
  map('n', '<leader>' .. mapping.key, lsp[mapping.cmd], { desc = 'lsp ' .. mapping.cmd:gsub('_', ' ') })
end

for _, diag in ipairs {
  { key = 'ds', cmd = 'show' },
  { key = 'dh', cmd = 'hide' },
  { key = 'dq', cmd = 'setqflist' },
  { key = 'dl', cmd = 'setloclist' },
} do
  map('n', '<leader>' .. diag.key, vim.diagnostic[diag.cmd], { desc = 'diagnostics ' .. diag.cmd:gsub('_', ' ') })
end
