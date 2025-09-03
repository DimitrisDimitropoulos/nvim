--- @class StatuslineModule
-- 'Statusline' is global so `vim.o.statusline` can find it.
Statusline = {}

local statusline_augroup = vim.api.nvim_create_augroup('Statusline', { clear = true })

-- Store configuration in one place.
Statusline.config = {
  max_width = 80,
  icons = {
    git = ' \u{e0a0} ',
    error = '\u{23FA} ',
    warn = '\u{23FA} ',
    info = '\u{23FA} ',
    hint = '\u{23FA} ',
  },
}

Statusline.modes = {
  ['n'] = 'NORMAL',
  ['no'] = 'NORMAL?',
  ['nov'] = 'NORMAL?',
  ['noV'] = 'NORMAL?',
  ['no\22'] = 'NORMAL?',
  ['niI'] = 'NORMALi',
  ['niR'] = 'NORMALR',
  ['niV'] = 'NORMALV',
  ['nt'] = 'NORMALt',
  ['v'] = 'VISUAL',
  ['vs'] = 'VISUALs',
  ['V'] = 'LINES',
  ['Vs'] = 'LINESs',
  ['\22'] = 'BLOCK',
  ['\22s'] = 'BLOCK',
  ['s'] = 'SUBSTITUTE',
  ['S'] = 'S_',
  ['\19'] = '^S',
  ['i'] = 'INSERT',
  ['ic'] = 'INSERTc',
  ['ix'] = 'INSERTx',
  ['R'] = 'REPLACE',
  ['Rc'] = 'REPLACEc',
  ['Rx'] = 'REPLACEx',
  ['Rv'] = 'REPLACEv',
  ['Rvc'] = 'REPLACEvc',
  ['Rvx'] = 'REPLACEx',
  ['c'] = 'COMMAND',
  ['cv'] = 'Ex',
  ['r'] = '...',
  ['rm'] = 'M',
  ['r?'] = '?',
  ['!'] = '!',
  ['t'] = 'TERMINAL',
}

--- @return string
function Statusline:mode()
  return string.format('%%#StatusLineMode# %s %%* ', Statusline.modes[vim.api.nvim_get_mode().mode])
end

--- A general-purpose helper to wrap content in a highlight group.
--- @param group string The highlight group name.
--- @param content string The text content to wrap.
--- @return string
function Statusline:_wrap_hl(group, content)
  if not content or content == '' then
    return ''
  end
  return string.format('%%#%s#%s%%*', group, content)
end

Statusline.lsp_progress = {}

vim.api.nvim_create_autocmd('LspProgress', {
  group = statusline_augroup,
  desc = 'LSP Progress Tracker',
  pattern = { 'begin', 'report', 'end' },
  callback = function(args)
    local data = args.data
    if not (data and data.client_id) then
      return
    end
    if data.params.value.kind == 'end' then
      Statusline.lsp_progress = {}
      vim.defer_fn(vim.cmd.redrawstatus, 500)
    else
      Statusline.lsp_progress = {
        client_name = vim.lsp.get_client_by_id(data.client_id).name,
        title = data.params.value.title,
        message = data.params.value.message,
        percentage = data.params.value.percentage,
      }
      vim.cmd.redrawstatus()
    end
  end,
})

--- Renders the current buffer's filename with modification/readonly status.
--- @return string
function Statusline:filename()
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
  if fname == '' then
    return '[No Name]'
  end
  if #fname > 15 then
    fname = vim.fn.pathshorten(fname)
  end
  if vim.bo.modified then
    return self:_wrap_hl('StatuslineModified', fname .. '[+]')
  end
  if not vim.bo.modifiable or vim.bo.readonly then
    return self:_wrap_hl('StatuslineReadonly', fname .. '[RO]')
  end
  return self:_wrap_hl('StatusLineFileName', fname)
end

--- Renders the current Git branch and its status.
--- @return string
function Statusline:git()
  local branch = vim.b.gitsigns_head
  local gsd = vim.b.gitsigns_status_dict
  if not branch and not gsd then
    return ''
  end
  local components = {}
  if branch and branch ~= '' then
    table.insert(components, self:_wrap_hl('StatusLineMedium', self.config.icons.git .. branch))
  end
  local diff_parts = {}
  local diff_types = {
    { key = 'added', prefix = '+', hl = 'StatuslineGitAdd' },
    { key = 'changed', prefix = '~', hl = 'StatuslineGitChange' },
    { key = 'removed', prefix = '-', hl = 'StatuslineGitRemoved' },
  }
  if gsd then
    for _, diff in ipairs(diff_types) do
      if gsd[diff.key] and gsd[diff.key] > 0 then
        table.insert(diff_parts, self:_wrap_hl(diff.hl, diff.prefix .. gsd[diff.key]))
      end
    end
  end
  if #diff_parts > 0 then
    table.insert(components, ' [' .. table.concat(diff_parts) .. ']')
  end
  return table.concat(components)
end

--- Renders the current buffer's diagnostics.
--- @return string
function Statusline:diagnostics()
  if package.loaded['vim.diagnostic'] == nil then
    return ''
  else
    local severities = {
      { level = vim.diagnostic.severity.ERROR, hl = 'DiagnosticFloatError', icon = self.config.icons.error },
      { level = vim.diagnostic.severity.WARN, hl = 'DiagnosticFloatWarn', icon = self.config.icons.warn },
      { level = vim.diagnostic.severity.HINT, hl = 'DiagnosticFloatHint', icon = self.config.icons.hint },
      { level = vim.diagnostic.severity.INFO, hl = 'DiagnosticFloatInfo', icon = self.config.icons.info },
    }
    local parts = {}
    for _, sev in ipairs(severities) do
      local count = #vim.diagnostic.get(0, { severity = sev.level })
      if count > 0 then
        table.insert(parts, self:_wrap_hl(sev.hl, sev.icon .. count))
      end
    end
    if #parts == 0 then
      return ''
    end
    return '![' .. table.concat(parts, ' ') .. ']'
  end
end

--- Renders the LSP progress message.
--- @return string
function Statusline:lsp_status()
  if package.loaded['vim.lsp'] == nil then
    return ''
  else
    local p = self.lsp_progress
    if not p or not p.title then
      return ''
    end
    local title = p.title
    local percentage = (p.percentage and string.format('%d%%', p.percentage)) or ''
    local message = p.message or ''
    local text = string.format('%s %s %s', title, message, percentage):gsub('%s+$', '')
    return self:_wrap_hl('StatusLineLspMessages', text .. ' ')
  end
end

--- Renders a list of active LSP clients for the buffer.
--- @return string
function Statusline:lsp_clients()
  if package.loaded['vim.lsp'] == nil then
    return ''
  else
    if vim.api.nvim_win_get_width(0) <= self.config.max_width then
      return ''
    end
    local clients = vim.lsp.get_clients { bufnr = vim.api.nvim_get_current_buf() }
    if next(clients) == nil then
      return ''
    end
    local client_names = {}
    for _, client in ipairs(clients) do
      table.insert(client_names, client.name)
    end
    return '[' .. table.concat(client_names, ' ') .. ']'
  end
end

--- Renders various file properties, grouped for clarity.
--- @return string
function Statusline:file_properties()
  if vim.api.nvim_win_get_width(0) <= self.config.max_width then
    return ''
  end
  local parts = {}
  table.insert(parts, ' [' .. vim.bo.filetype .. ']')
  if vim.bo.fenc ~= 'utf-8' and vim.bo.fenc ~= '' then
    table.insert(parts, self:_wrap_hl('StatusLineMedium', ' [' .. vim.bo.fenc .. ']'))
  end
  if vim.wo.spell and vim.bo.filetype ~= 'markdown' and vim.bo.filetype ~= 'tex' then
    table.insert(parts, self:_wrap_hl('StatusLineMedium', ' [SPELL]'))
  end
  if vim.bo.filetype == 'tex' and vim.o.keymap ~= '' then
    table.insert(parts, ' [' .. vim.o.keymap .. ']')
  end
  return table.concat(parts)
end

--- Renders the ruler (line:column).
--- @return string
function Statusline:ruler()
  return self:_wrap_hl('StatusLineRuler', ' ' .. vim.fn.line '.' .. ':' .. vim.fn.col '.')
end

Statusline.layout = {
  Statusline.mode,
  Statusline.filename,
  Statusline.git,
  ' ',
  Statusline.diagnostics,
  '%=',
  Statusline.lsp_status,
  '%=',
  Statusline.lsp_clients,
  Statusline.file_properties,
  Statusline.ruler,
  ' ',
}

--- The main function called by Vim's 'statusline' option.
function Statusline.active()
  local components = {}
  for _, part in ipairs(Statusline.layout) do
    if type(part) == 'function' then
      table.insert(components, part(Statusline))
    else
      table.insert(components, part)
    end
  end
  return table.concat(components)
end

vim.o.statusline = '%!v:lua.Statusline.active()'

local function get_hl(name)
  return vim.api.nvim_get_hl(0, { name = name, link = false })
end
vim.api.nvim_set_hl(0, 'StatusLine', { link = 'CursorLine' })
local bg = get_hl('Statusline').bg
local fg = get_hl('Statusline').fg

for name, attrs in pairs {
  ['DiagnosticFloatError'] = { bg = bg, fg = get_hl('DiagnosticError').fg },
  ['DiagnosticFloatWarn'] = { bg = bg, fg = get_hl('DiagnosticWarn').fg },
  ['DiagnosticFloatHint'] = { bg = bg, fg = get_hl('DiagnosticHint').fg },
  ['DiagnosticFloatInfo'] = { bg = bg, fg = get_hl('DiagnosticInfo').fg },
  ['StatuslineGitAdd'] = { bg = bg, fg = get_hl('GitSignsAdd').fg },
  ['StatuslineGitChange'] = { bg = bg, fg = get_hl('GitSignsChange').fg },
  ['StatuslineGitRemoved'] = { bg = bg, fg = get_hl('GitSignsDelete').fg },
  ['StatusLineMedium'] = { bg = bg, fg = '#f6d5a4', bold = true },
  ['StatusLineRuler'] = { bg = bg, fg = get_hl('Keyword').fg, bold = true },
  ['StatusLineLspMessages'] = { bg = bg, fg = '#f6d5a4' },
  ['StatusLineFileName'] = { bg = bg, fg = fg, italic = true },
  ['StatuslineModified'] = { bg = bg, fg = fg, italic = true, bold = true },
  ['StatuslineReadonly'] = { bg = bg, fg = fg },
} do
  vim.api.nvim_set_hl(0, name, attrs)
end

Statusline.mode_colors = {
  ['n'] = '#d4bfff',
  ['i'] = '#fabd2f',
  ['v'] = 'purple',
  ['V'] = '#d3869b',
  ['\22'] = 'magenta',
  ['c'] = '#b8bb26',
  ['s'] = 'purple',
  ['S'] = 'purple',
  ['\19'] = 'purple',
  ['R'] = 'orange',
  ['r'] = 'orange',
  ['!'] = '#fb4934',
  ['t'] = '#f6d5a4',
}
vim.api.nvim_create_autocmd('ModeChanged', {
  group = statusline_augroup,
  pattern = '*:*',
  callback = function()
    vim.api.nvim_set_hl(
      0,
      'StatusLineMode',
      { fg = '#000000', bold = true, bg = Statusline.mode_colors[vim.api.nvim_get_mode().mode:sub(1, 1)] }
    )
    vim.schedule_wrap(function()
      vim.cmd.redrawstatus()
    end)
  end,
})

vim.api.nvim_set_hl(0, 'SnippetTabstopActive', { link = 'PmenuSel' })
