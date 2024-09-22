-- -----------+
-- Statusline │
-- -----------+

local statusline_augroup = vim.api.nvim_create_augroup('Statusline', { clear = true })
local max = 80

local modes = {
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
local function mode()
  return string.format('%%#StatusLineMode# %s %%* ', modes[vim.api.nvim_get_mode().mode])
end

--- @return string
local function filename()
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
  if fname == '' then
    return '[No Name]'
  end
  if #fname > 15 then
    fname = vim.fn.pathshorten(fname)
  end
  if vim.bo.modified then
    fname = fname .. '[+]'
    return string.format('%%#StatuslineModified#%s%%*', fname)
  end
  if not vim.bo.modifiable or vim.bo.readonly then
    fname = fname .. '[RO]'
    return string.format('%%#StatuslineReadonly#%s%%*', fname)
  else
    return string.format('%%#StatusLineFileName#%s%%*', fname)
  end
end

--- @param type string
--- @return integer
local function get_git_diff(type)
  local gsd = vim.b.gitsigns_status_dict
  if gsd and gsd[type] then
    return gsd[type]
  end
  return 0
end
--- @return string
local function git_diff_added()
  local added = get_git_diff 'added'
  if added > 0 then
    return string.format('%%#StatuslineGitAdd#+%s%%*', added)
  end
  return ''
end
--- @return string
local function git_diff_changed()
  local changed = get_git_diff 'changed'
  if changed > 0 then
    return string.format('%%#StatuslineGitChange#~%s%%*', changed)
  end
  return ''
end
--- @return string
local function git_diff_removed()
  local removed = get_git_diff 'removed'
  if removed > 0 then
    return string.format('%%#StatuslineGitRemoved#-%s%%*', removed)
  end
  return ''
end
--- @return string
local function git_branch()
  local branch = vim.b.gitsigns_head
  if branch == '' or branch == nil then
    return ''
  end
  return string.format('%%#StatusLineMedium#\u{e0a0} %s%%*', branch)
end
--- @return string
local function full_git()
  if vim.b.gitsigns_head or vim.b.gitsigns_status_dict then
    local full = ''
    local space = ' '
    local branch = git_branch()
    local added = git_diff_added()
    local changed = git_diff_changed()
    local removed = git_diff_removed()
    if branch ~= '' then
      full = full .. space .. branch
    end
    local git_status = ''
    if added ~= '' then
      git_status = git_status .. added
    end
    if changed ~= '' then
      git_status = git_status .. changed
    end
    if removed ~= '' then
      git_status = git_status .. removed
    end
    if git_status ~= '' then
      full = full .. ' [' .. git_status .. ']'
    end
    return full
  else
    return ''
  end
end

local function diagnostic_total()
  if #vim.diagnostic.get(0) > 0 then
    local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    local full = ''
    full = full .. '!['
    if errors > 0 then
      full = full .. string.format('%%#DiagnosticFloatError#\u{23FA} %s%%*', errors)
    end
    if warnings > 0 then
      full = full .. string.format('%%#DiagnosticFloatWarn#\u{23FA} %s%%*', warnings)
    end
    if hints > 0 then
      full = full .. string.format('%%#DiagnosticFloatHint#\u{23FA} %s%%*', hints)
    end
    if info > 0 then
      full = full .. string.format('%%#DiagnosticFloatInfo#\u{23FA} %s%%*', info)
    end
    return full .. ']'
  else
    return ''
  end
end

--- @class LspProgress
--- @field client vim.lsp.Client?
--- @field kind string?
--- @field title string?
--- @field percentage integer?
--- @field message string?
local lsp_progress = {
  client = nil,
  kind = nil,
  title = nil,
  percentage = nil,
  message = nil,
}
vim.api.nvim_create_autocmd('LspProgress', {
  group = statusline_augroup,
  desc = 'LSP Progress',
  pattern = { 'begin', 'report', 'end' },
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end
    lsp_progress = {
      client = vim.lsp.get_client_by_id(args.data.client_id),
      kind = args.data.params.value.kind,
      message = args.data.params.value.message,
      percentage = args.data.params.value.percentage,
      title = args.data.params.value.title,
    }
    if lsp_progress.kind == 'end' then
      lsp_progress.title = nil
      vim.defer_fn(function()
        vim.cmd.redrawstatus()
      end, 500)
    else
      vim.cmd.redrawstatus()
    end
  end,
})
--- @return string
local function lsp_status()
  if not rawget(vim, 'lsp') then
    return ''
  end
  if not lsp_progress.client or not lsp_progress.title then
    return ''
  end
  local title = lsp_progress.title or ''
  local percentage = (lsp_progress.percentage and (lsp_progress.percentage .. '%%')) or ''
  local message = lsp_progress.message or ''
  local lsp_message = string.format('%s', title)
  if message ~= '' then
    lsp_message = string.format('%s %s', lsp_message, message)
  end
  if percentage ~= '' then
    lsp_message = string.format('%s %s', lsp_message, percentage)
  end
  return string.format('%%#StatusLineLspMessages#%s%%* ', lsp_message)
end

-- LSP clients attached to buffer
local function lsp_clients()
  local current_buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { bufnr = current_buf }
  if next(clients) == nil then
    return ''
  end
  local c = {}
  for _, client in pairs(clients) do
    table.insert(c, client.name)
  end
  if vim.api.nvim_win_get_width(0) > max then
    return '[' .. table.concat(c, ' ') .. ']'
  else
    return ''
  end
end

local function filetype()
  if vim.api.nvim_win_get_width(0) > max then
    return ' [' .. vim.bo.filetype .. ']'
  else
    return ''
  end
end

local function is_spell()
  if vim.wo.spell and vim.bo.filetype ~= 'markdown' and vim.bo.filetype ~= 'tex' then
    -- return ' [SPELL]'
    return string.format '%%#StatusLineMedium# [SPELL]%%*'
  else
    return ''
  end
end

local function is_keymap()
  if vim.bo.filetype == 'tex' and vim.opt.keymap:get() ~= '' then
    return ' [' .. vim.opt.keymap:get() .. ']'
  else
    return ''
  end
end

local function file_encoding()
  if vim.bo.fenc ~= 'utf-8' and vim.bo.fenc ~= '' then
    return string.format('%%#StatusLineMedium# [%s]%%*', vim.bo.fenc)
  else
    return ''
  end
end

local function ruler()
  -- return ' %l:%c'
  return string.format('%%#StatusLineRuler# %s%%*', vim.fn.line '.' .. ':' .. vim.fn.col '.')
end

StatusLine = {}
StatusLine.active = function()
  return table.concat {
    mode(),
    filename(),
    full_git(),
    ' ',
    diagnostic_total(),
    '%=',
    lsp_status(),
    '%=',
    lsp_clients(),
    filetype(),
    file_encoding(),
    is_spell(),
    is_keymap(),
    ruler(),
    ' ',
  }
end

vim.opt.statusline = '%!v:lua.StatusLine.active()'

local function get_hl(name)
  return vim.api.nvim_get_hl(0, { name = name, link = false })
end
local bg = get_hl('Statusline').bg
local fg = get_hl('Statusline').fg
vim.api.nvim_set_hl(0, 'DiagnosticFloatError', { bg = bg, fg = get_hl('DiagnosticError').fg })
vim.api.nvim_set_hl(0, 'DiagnosticFloatWarn', { bg = bg, fg = get_hl('DiagnosticWarn').fg })
vim.api.nvim_set_hl(0, 'DiagnosticFloatHint', { bg = bg, fg = get_hl('DiagnosticHint').fg })
vim.api.nvim_set_hl(0, 'DiagnosticFloatInfo', { bg = bg, fg = get_hl('DiagnosticInfo').fg })
vim.api.nvim_set_hl(0, 'StatuslineGitAdd', { bg = bg, fg = get_hl('GitSignsAdd').fg })
vim.api.nvim_set_hl(0, 'StatuslineGitChange', { bg = bg, fg = get_hl('GitSignsChange').fg })
vim.api.nvim_set_hl(0, 'StatuslineGitRemoved', { bg = bg, fg = get_hl('GitSignsDelete').fg })
vim.api.nvim_set_hl(0, 'StatusLineMedium', { bg = bg, fg = '#f6d5a4', bold = true })
vim.api.nvim_set_hl(0, 'StatusLineRuler', { bg = bg, fg = get_hl('Keyword').fg, bold = true })
vim.api.nvim_set_hl(0, 'StatusLineLspMessages', { bg = bg, fg = '#f6d5a4' })
vim.api.nvim_set_hl(0, 'StatusLineFileName', { bg = bg, fg = fg, italic = true })
vim.api.nvim_set_hl(0, 'StatuslineModified', { bg = bg, fg = fg, italic = true, bold = true })
vim.api.nvim_set_hl(0, 'StatuslineReadonly', { bg = bg, fg = fg })

local mode_colors = {
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
      { fg = '#000000', bold = true, bg = mode_colors[vim.api.nvim_get_mode().mode:sub(1, 1)] }
    )
    vim.schedule_wrap(function()
      vim.cmd.redrawstatus()
    end)
  end,
})
