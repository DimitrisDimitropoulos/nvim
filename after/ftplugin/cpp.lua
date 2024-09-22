local util = require 'lspconfig.util'

local function format_mem_tree(node, padding)
  local result = {}
  -- Add the total memory usage at the top level
  if padding == '' then
    table.insert(result, string.format('Total: self = %s, total = %s', node._self, node._total))
  end
  -- Recursively format the memory tree
  for child_name, child_node in pairs(node) do
    if child_name ~= '_self' and child_name ~= '_total' then
      table.insert(
        result,
        padding .. string.format('%s: self = %s, total = %s', child_name, child_node._self, child_node._total)
      )
      -- Recursively format the "preamble" node
      if child_name ~= 'preamble' then
        vim.list_extend(result, format_mem_tree(child_node, padding .. '  '))
      end
    end
  end
  return result
end

local function mem_handler(err, result)
  if err or not result then
    return
  end
  vim.cmd 'split MemoryUsage'
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = format_mem_tree(result, '')
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
  vim.bo[bufnr].modifiable = false
  vim.bo[bufnr].buftype = 'nofile'
  vim.bo[bufnr].bufhidden = 'wipe'
  vim.api.nvim_win_set_height(0, math.min(#lines, 20))
  vim.keymap.set('n', 'q', '<cmd>q<CR>', { noremap = true, silent = true, buffer = bufnr })
end

local function show_memory_usage()
  local bufnr = vim.api.nvim_get_current_buf()
  local clangd_client = util.get_active_client_by_name(bufnr, 'clangd')
  if not clangd_client then
    return vim.notify('Clangd client not found', vim.log.levels.ERROR)
  end
  clangd_client.request('$/memoryUsage', nil, mem_handler, bufnr)
end

vim.api.nvim_create_user_command('ClangdShowMemoryUsage', function()
  show_memory_usage()
end, { nargs = 0, desc = 'Show memory usage with optional preamble expansion' })

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
