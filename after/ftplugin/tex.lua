vim.opt.cursorlineopt = 'number'
vim.opt_local.spell = true
vim.opt_local.wrap = true

local function moving_wrap(direction) return (vim.v.count == 0) and 'g' .. direction or direction end
vim.keymap.set({ 'n', 'x' }, 'k', function() return moving_wrap 'k' end, { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'j', function() return moving_wrap 'j' end, { expr = true, silent = true })

-- BUG: For some reason this does not work, @2024-01-25 01:51:09
vim.cmd.syntax 'spell toplevel'

local util = require 'lspconfig.util'

local function buf_cancel_build(bufnr)
  bufnr = util.validate_bufnr(0) or bufnr
  local texlab_client = util.get_active_client_by_name(bufnr, 'texlab')
  if texlab_client then
    local pars = { command = 'texlab.cancelBuild', }
    vim.lsp.buf.execute_command(pars)
    vim.notify('Build cancelled', vim.log.levels.INFO)
  else
    vim.notify('Texlab client not found', vim.log.levels.ERROR)
  end
end

local function dependency_graph(bufnr)
  bufnr = util.validate_bufnr(0) or bufnr
  local texlab_client = util.get_active_client_by_name(bufnr, 'texlab')
  if texlab_client then
    texlab_client.request('workspace/executeCommand', { command = 'texlab.showDependencyGraph' }, function(err, result)
      if err then error(tostring(err)) end
      vim.notify('The dependency graph has been generated:\n' .. result, vim.log.levels.INFO)
    end, 0)
  else
    vim.notify('Texlab client not found', vim.log.levels.ERROR)
  end
end

local function cleanArtifacts(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local texlab_client = util.get_active_client_by_name(bufnr, 'texlab')
  if not texlab_client then
    vim.notify('Texlab client not found', vim.log.levels.ERROR)
    return
  end
  local pars = {
    command = 'texlab.cleanArtifacts',
    arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
  }
  vim.lsp.buf.execute_command(pars)
  vim.notify('Artifacts cleaned successfully', vim.log.levels.INFO)
end

local function cleanAuxiliary(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local texlab_client = util.get_active_client_by_name(bufnr, 'texlab')
  if not texlab_client then
    vim.notify('Texlab client not found', vim.log.levels.ERROR)
    return
  end
  local pars = {
    command = 'texlab.cleanAuxiliary',
    arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
  }
  vim.lsp.buf.execute_command(pars)
  vim.notify('Auxiliary files cleaned successfully', vim.log.levels.INFO)
end

local coms = {
  { name = 'TexlabCancel',          func = buf_cancel_build, desc = 'Cancel build, includes the onSave' },
  { name = 'TexlabDependencyGraph', func = dependency_graph, desc = 'Generate dependency graph in DOT' },
  { name = 'TexlabCleanArtifacts',  func = cleanArtifacts,   desc = 'Clean artifacts, latexmk -C' },
  { name = 'TexlabCleanAuxiliary',  func = cleanAuxiliary,   desc = 'Clean auxiliary, latexmk -c' },
}
for _, com in ipairs(coms) do
  vim.api.nvim_create_user_command(com.name, function() com.func(0) end, { nargs = 0, desc = com.desc })
end
