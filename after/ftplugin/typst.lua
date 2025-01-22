---@param command_name string
local function create_tinymist_command(command_name)
  local export_type = command_name:match 'tinymist%.export(%w+)'
  local info_type = command_name:match 'tinymist%.(%w+)'
  if info_type and info_type:match '^get' then
    info_type = info_type:gsub('^get', 'Get')
  end
  local cmd_display = export_type or info_type
  ---Execute the Tinymist command, supporting both 0.10 and 0.11 exec methods
  ---@return nil
  local function run_tinymist_command()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = vim.lsp.get_clients({ filter = { name = 'tinymist', buffer = bufnr } })[1]
    if not client then
      return vim.notify('No Tinymist client attached to the current buffer', vim.log.levels.ERROR)
    end
    local arguments = { vim.uri_to_fname(vim.uri_from_bufnr(bufnr)) }
    local title_str = export_type and ('Export ' .. cmd_display) or cmd_display
    local function handler(err, res)
      if err then
        return vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
      end
      -- If exporting, show the string result; else, show the table for inspection
      vim.notify(export_type and res or vim.inspect(res), vim.log.levels.INFO)
    end
    if vim.fn.has 'nvim-0.11' == 1 then
      -- For Neovim 0.11+
      return client:exec_cmd({
        title = title_str,
        command = command_name,
        arguments = arguments,
      }, { bufnr = bufnr }, handler)
    else
      -- For Neovim < 0.11
      return client.request('workspace/executeCommand', {
        command = command_name,
        arguments = arguments,
      }, handler, bufnr)
    end
  end
  -- Construct a readable command name/desc
  local cmd_name = export_type and ('TinymistExport' .. cmd_display) or ('Tinymist' .. cmd_display)
  local cmd_desc = export_type and ('Export to ' .. cmd_display) or ('Get ' .. cmd_display)
  return run_tinymist_command, cmd_name, cmd_desc
end
for _, command in ipairs {
  'tinymist.exportSvg',
  'tinymist.exportPng',
  'tinymist.exportPdf',
  'tinymist.exportHtml',
  'tinymist.exportMarkdown',
  'tinymist.exportText',
  'tinymist.exportQuery',
  'tinymist.exportAnsiHighlight',
  'tinymist.getServerInfo',
  'tinymist.getDocumentTrace',
  'tinymist.getWorkspaceLabels',
  'tinymist.getDocumentMetrics',
} do
  local cmd_func, cmd_name, cmd_desc = create_tinymist_command(command)
  vim.api.nvim_create_user_command(cmd_name, cmd_func, { nargs = 0, desc = cmd_desc })
end

