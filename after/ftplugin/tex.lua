vim.opt.cursorlineopt = 'number'
vim.opt_local.spell = true
vim.opt_local.wrap = true

local function moving_wrap(direction) return (vim.v.count == 0) and 'g' .. direction or direction end
vim.keymap.set({ 'n', 'x' }, 'k', function() return moving_wrap 'k' end, { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'j', function() return moving_wrap 'j' end, { expr = true, silent = true })

-- BUG: For some reason this does not work, @2024-01-25 01:51:09
vim.cmd.syntax 'spell toplevel'

local util = require 'lspconfig.util'
local function buf_cancel_build()
  local texlab_client = util.get_active_client_by_name(0, 'texlab')
  if texlab_client then
    texlab_client.request('workspace/executeCommand', { command = 'texlab.cancelBuild' }, function(err)
      if err then error(tostring(err)) end
      print 'Build cancelled'
    end, 0)
  end
end
vim.api.nvim_create_user_command(
  'TexlabCancel',
  function() buf_cancel_build() end,
  { nargs = 0, desc = 'Cancel build, includes the onSave' }
)

local function dependency_graph()
  local texlab_client = util.get_active_client_by_name(0, 'texlab')
  if texlab_client then
    texlab_client.request('workspace/executeCommand', { command = 'texlab.showDependencyGraph' }, function(err, result)
      if err then error(tostring(err)) end
      vim.notify('The dependency graph has been generated:\n' .. result)
    end, 0)
  end
end
vim.api.nvim_create_user_command(
  'TexlabDependencyGraph',
  function() dependency_graph() end,
  { nargs = 0, desc = 'Generate dependency graph in DOT' }
)

local function cleanArtifacts(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local texlab_client = util.get_active_client_by_name(bufnr, 'texlab')
  if not texlab_client then
    vim.notify 'Texlab client not found'
    return
  end
  local params = {
    command = 'texlab.cleanArtifacts',
    arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
  }
  texlab_client.request('workspace/executeCommand', params, function(err, _, _)
    if err then
      error(tostring(err))
    else
      vim.notify 'Artifacts cleaned successfully'
    end
  end, 0)
end
vim.api.nvim_create_user_command(
  'TexlabCleanArtifacts',
  function() cleanArtifacts(0) end,
  { nargs = 0, desc = 'Clean artifacts, latexmk -C' }
)

local function cleanAuxliary(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local texlab_client = util.get_active_client_by_name(bufnr, 'texlab')
  if not texlab_client then
    vim.notify 'Texlab client not found'
    return
  end
  local params = {
    command = 'texlab.cleanAuxiliary',
    arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
  }
  texlab_client.request('workspace/executeCommand', params, function(err, _, _)
    if err then
      error(tostring(err))
    else
      vim.notify 'Auxiliary cleaned successfully'
    end
  end, 0)
end
vim.api.nvim_create_user_command(
  'TexlabCleanAuxiliary',
  function() cleanAuxliary(0) end,
  { nargs = 0, desc = 'Clean auxiliary, latexmk -c' }
)
