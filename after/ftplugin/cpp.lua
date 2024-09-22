local util = require 'lspconfig.util'

local function memory_usage(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local clangd_client = util.get_active_client_by_name(bufnr, 'clangd')
  if not clangd_client then
    return vim.notify('Clangd client not found', vim.log.levels.ERROR)
  end
  vim.lsp.buf_request(0, '$/memoryUsage', nil, function(err, res)
    if err then
      return
    end
    return vim.notify('Memory usage:\n' .. vim.inspect(res), vim.log.levels.INFO)
  end)
end
vim.api.nvim_create_user_command('ClangdMemoryUsage', function()
  memory_usage(0)
end, { nargs = 0 })

local function type_hierarchy(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local clangd_client = util.get_active_client_by_name(bufnr, 'clangd')
  if not clangd_client then
    return vim.notify('Clangd client not found', vim.log.levels.ERROR)
  end
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.lsp.buf_request(0, 'textDocument/typeHierarchy', {
    textDocument = { uri = vim.uri_from_bufnr(0) },
    position = { line = pos[1] - 1, character = pos[2] },
  }, function(err, res)
    if err then
      return
    end
    return vim.notify('Type Hierarchy:\n' .. vim.inspect(res), vim.log.levels.INFO)
  end)
end
vim.api.nvim_create_user_command('ClangdTypeHierarchy', function()
  type_hierarchy(0)
end, { nargs = 0 })
