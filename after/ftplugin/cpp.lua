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

local function format_hier_tree(node, padding)
  local result = {}
  -- Format the current node with simplified type name and a fixed "Class" kind
  table.insert(result, padding .. '• ' .. node.name .. ': Class')
  -- Format parents recursively
  if node.parents then
    for _, parent in pairs(node.parents) do
      table.insert(result, padding .. '  Parents:')
      vim.list_extend(result, format_hier_tree(parent, padding .. '    '))
    end
  end
  -- Format children recursively
  if node.children then
    for _, child in pairs(node.children) do
      table.insert(result, padding .. '  Children:')
      vim.list_extend(result, format_hier_tree(child, padding .. '    '))
    end
  end

  return result
end

local function hier_handler(err, TypeHierarchyItem, _)
  if err or not TypeHierarchyItem then
    return
  end
  vim.cmd.split(TypeHierarchyItem.name .. ': type hierarchy')
  local bufnr = vim.api.nvim_get_current_buf()
  -- Format the tree and set it as the buffer content
  local lines = format_hier_tree(TypeHierarchyItem, '')
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
  vim.bo[bufnr].modifiable = false
  vim.bo[bufnr].filetype = 'ClangdTypeHierarchy'
  vim.bo[bufnr].buftype = 'nofile'
  vim.bo[bufnr].bufhidden = 'wipe'
  vim.bo[bufnr].buflisted = true
  vim.api.nvim_win_set_height(0, math.min(#lines, 15))
  vim.keymap.set('n', 'q', '<cmd>q<CR>', { noremap = true, silent = true, buffer = bufnr })
end

local function type_hierarchy()
  local bufnr = vim.api.nvim_get_current_buf()
  local clangd_client = util.get_active_client_by_name(bufnr, 'clangd')
  if not clangd_client then
    return vim.notify('Clangd client not found', vim.log.levels.ERROR)
  end
  local pos = vim.api.nvim_win_get_cursor(0)
  clangd_client.request('textDocument/typeHierarchy', {
    textDocument = { uri = vim.uri_from_bufnr(0) },
    position = { line = pos[1] - 1, character = pos[2] },
    resolve = 3,
    direction = 2,
  }, hier_handler, bufnr)
end

vim.api.nvim_create_user_command('ClangdShowTypeHierarchy', function()
  type_hierarchy()
end, { nargs = 0, desc = 'Show type hierarchy' })
