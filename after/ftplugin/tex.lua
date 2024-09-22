vim.opt_local.spell = true
vim.opt_local.wrap = true

local function moving_wrap(direction) return (vim.v.count == 0) and 'g' .. direction or direction end
vim.keymap.set({ 'n', 'x' }, 'k', function() return moving_wrap 'k' end, { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'j', function() return moving_wrap 'j' end, { expr = true, silent = true })

-- BUG: For some reason this does not work, @2024-01-25 01:51:09
vim.cmd.syntax 'spell toplevel'

local util = require 'lspconfig.util'

local function buf_change_env(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  if not util.get_active_client_by_name(bufnr, 'texlab') then
    return vim.notify('Texlab client not found', vim.log.levels.ERROR)
  end
  local new = vim.fn.input('Enter the new environment name: ')
  if not new or new == '' then
    return vim.notify('No environment name provided', vim.log.levels.WARN)
  end
  new = tostring(new)
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.lsp.buf.execute_command({
    command = 'texlab.changeEnvironment',
    arguments = { {
      textDocument = { uri = vim.uri_from_bufnr(bufnr), },
      position = { line = pos[1] - 1, character = pos[2] },
      newName = new
    } }
  })
end
vim.api.nvim_create_user_command(
  'TexlabChangeEnvironment',
  function() buf_change_env(0) end,
  { nargs = 0, desc = 'Change the current environment based on position' })

local function buf_find_envs(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local texlab_client = util.get_active_client_by_name(bufnr, 'texlab')
  if not texlab_client then
    return vim.notify('Texlab client not found', vim.log.levels.ERROR)
  end
  local pos = vim.api.nvim_win_get_cursor(0)
  texlab_client.request('workspace/executeCommand', {
      command = 'texlab.findEnvironments',
      arguments = { {
        textDocument = { uri = vim.uri_from_bufnr(bufnr), },
        position = { line = pos[1] - 1, character = pos[2] },
      } },
    },
    function(err, result)
      if err then
        return vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
      end
      return vim.notify('The environments are:\n' .. vim.inspect(result), vim.log.levels.INFO)
    end, bufnr)
end
vim.api.nvim_create_user_command(
  'TexlabFindEnvironments',
  function() buf_find_envs(0) end,
  { nargs = 0, desc = 'Find the environments at the current cursor position' })
