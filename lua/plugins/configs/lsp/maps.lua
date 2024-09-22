local map = vim.keymap.set
local lsp = vim.lsp.buf
local lsp_mappings = {
  { key = 'gi', cmd = 'implementation' },
  { key = 'kk', cmd = 'signature_help' },
  { key = 'gh', cmd = 'type_definition' },
  { key = 'wa', cmd = 'add_workspace_folder' },
  { key = 'wr', cmd = 'remove_workspace_folder' },
}

local diagno = {
  { key = 'ds', cmd = 'show' },
  { key = 'dh', cmd = 'hide' },
  { key = 'dl', cmd = 'setqflist' },
}

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
map('n', '<A-f>', function()
  lsp.format { async = true }
end, { desc = 'lsp async format' })
map('n', '<space>wl', function()
  print(vim.inspect(lsp.list_workspace_folders()))
end, { desc = 'lsp list workspace folders' })
for _, mapping in ipairs(lsp_mappings) do
  map('n', '<leader>' .. mapping.key, lsp[mapping.cmd], { desc = 'lsp ' .. mapping.cmd:gsub('_', ' ') })
end

for _, diag in ipairs(diagno) do
  map('n', '<leader>' .. diag.key, vim.diagnostic[diag.cmd], { desc = 'diagnostics ' .. diag.cmd:gsub('_', ' ') })
end
