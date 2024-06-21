local map = vim.keymap.set
local lsp = vim.lsp.buf
local lsp_mappings = {
  { key = 'gi', cmd = 'implementation',          desc = 'goto impl' },
  { key = 'kk', cmd = 'signature_help',          desc = 'signature' },
  { key = 'gh', cmd = 'type_definition',         desc = 'type definition' },
  { key = 'wa', cmd = 'add_workspace_folder',    desc = 'add work folder' },
  { key = 'wr', cmd = 'remove_workspace_folder', desc = 'rm work folder' },
}

local diagno = {
  { key = '<leader>ds', cmd = 'show',      descr = 'diagnostics show' },
  { key = '<leader>dh', cmd = 'hide',      descr = 'diagnostics hide' },
  { key = '<leader>dl', cmd = 'setqflist', descr = 'diagnostics to loclist' },
}

map('n', '<leader>lh', function()
  if vim.lsp.inlay_hint.is_enabled() then
    vim.lsp.inlay_hint.enable(false)
  else
    vim.lsp.inlay_hint.enable(true)
  end
end, { desc = 'toggle inlay hints' })
map('n', '<A-f>', function() lsp.format { async = true } end, { desc = 'async format' })
map(
  'n',
  '<space>wl',
  function() print(vim.inspect(lsp.list_workspace_folders())) end,
  { desc = 'list workspace folders' }
)
for _, mapping in ipairs(lsp_mappings) do
  map('n', '<leader>' .. mapping.key, lsp[mapping.cmd], { desc = mapping.desc })
end

for _, diag in ipairs(diagno) do
  map('n', diag.key, vim.diagnostic[diag.cmd], { desc = diag.descr })
end
