local conditions = require 'heirline.conditions'
local utils = require 'heirline.utils'

local color = {
  bg = utils.get_highlight('Visual').bg,
  bright_bg = utils.get_highlight('Folded').bg,
  bright_fg = utils.get_highlight('Folded').fg,
  peanut = '#f6d5a4',
  yellow = '#fabd2f',
  red = '#fb4934',
  pink = '#d3869b',
  violet = '#d4bfff',
  light_green = '#b8bb26',
  diag_warn = utils.get_highlight('DiagnosticWarn').fg,
  diag_error = utils.get_highlight('DiagnosticError').fg,
  diag_hint = utils.get_highlight('DiagnosticHint').fg,
  diag_info = utils.get_highlight('DiagnosticInfo').fg,
  git_add = '#b8bb26',
  git_change = '#ffffff',
}
require('heirline').load_colors(color)

local ViMode = {
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()
  end,
  static = {
    mode_names = {
      n = 'NORMAL',
      no = 'NORMAL?',
      nov = 'NORMAL?',
      noV = 'NORMAL?',
      ['no\22'] = 'NORMAL?',
      niI = 'NORMALi',
      niR = 'NORMALR',
      niV = 'NORMALV',
      nt = 'NORMALt',
      v = 'VISUAL',
      vs = 'VISUALs',
      V = 'LINES',
      Vs = 'LINESs',
      ['\22'] = 'BLOCK',
      ['\22s'] = 'BLOCK',
      s = 'SUBSTITUTE',
      S = 'S_',
      ['\19'] = '^S',
      i = 'INSERT',
      ic = 'INSERTc',
      ix = 'INSERTx',
      R = 'REPLACE',
      Rc = 'REPLACEc',
      Rx = 'REPLACEx',
      Rv = 'REPLACEv',
      Rvc = 'REPLACEvc',
      Rvx = 'REPLACEx',
      c = 'COMMAND',
      cv = 'Ex',
      r = '...',
      rm = 'M',
      ['r?'] = '?',
      ['!'] = '!',
      t = 'TERMINAL',
    },

    mode_colors = {
      n = 'violet',
      i = 'yellow',
      v = 'purple',
      V = 'pink',
      ['\22'] = 'magenta',
      c = 'light_green',
      s = 'purple',
      S = 'purple',
      ['\19'] = 'purple',
      R = 'orange',
      r = 'orange',
      ['!'] = 'red',
      t = '#f6d5a4',
    },
  },
  provider = function(self) return ' %2(' .. self.mode_names[self.mode] .. '%) ' end,
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = 'black', bg = self.mode_colors[mode], bold = true }
  end,
  update = { 'ModeChanged', pattern = '*:*', callback = vim.schedule_wrap(function() vim.cmd 'redrawstatus' end) },
}

local FileNameBlock = { init = function(self) self.filename = vim.api.nvim_buf_get_name(0) end }

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self) return ' ' .. self.icon .. ' ' and ' ' .. self.icon .. ' ' end,
  hl = function(self) return { fg = self.icon_color, bg = 'bg' } end,
}

local FileName = {
  provider = function(self)
    local filename = vim.fn.fnamemodify(self.filename, ':.')
    if filename == '' then return '[No Name]' end
    if not conditions.width_percent_below(#filename, 0.25) then filename = vim.fn.pathshorten(filename) end
    return filename
  end,
  hl = { bg = 'bg', italic = true },
}

local FileFlags = {
  {
    condition = function() return vim.bo.modified end,
    provider = '[+]',
    hl = { fg = 'fg', bg = 'bg', italic = true },
  },
  {
    condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
    provider = '[RO]',
    hl = { fg = 'fg', bg = 'bg', italic = true },
  },
}

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = 'fg', bold = true, force = true }
    end
  end,
}

FileNameBlock = utils.insert(
  FileNameBlock,
  FileIcon,
  utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
  FileFlags,
  { provider = '%<' } -- this means that the statusline is cut here when there's not enough space
)

local FileType = {
  provider = function() return '[' .. vim.bo.filetype .. ']' end,
  hl = { fg = utils.get_highlight('String').fg, bold = true, bg = 'bg' },
}

local Ruler = { provider = '%l:%c', hl = { fg = 'yellow', bg = 'bg', bold = true } }

local LSPActive = {
  condition = conditions.lsp_attached,
  update = { 'LspAttach', 'LspDetach' },
  provider = function()
    local names = {}
    for _, server in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
      table.insert(names, server.name)
    end
    return '  [' .. table.concat(names, ' ') .. ']'
  end,
  hl = { fg = 'pink', bg = 'bg', bold = true },
}

local lsp_progress = function()
  -- if vim.bo.filetype == 'julia' then return '' end
  local lsp
  local version = vim.version()
  if version.minor == 9 then
    lsp = vim.lsp.util.get_progress_messages()[1]
    if lsp then
      local name = lsp.name or ''
      local msg = lsp.message or ''
      local title = lsp.title or ''
      return string.format(' %%<%s %s %s ', name, title, msg)
    end
  end
  -- NOTE: nightly support, @2023-07-28 18:12:44
  if version.minor == 10 then
    local lsp_out = tostring(vim.inspect(vim.lsp.status()))
    if lsp_out == '""' then return '' end
    return lsp_out
  end
  return ''
end

local LSPMessages = {
  condition = function() return #vim.lsp.buf_get_clients() > 0 end,
  provider = function() return lsp_progress() or '' end,
  hl = { fg = 'peanut', bg = 'bg' },
}

local Diagnostics = {
  condition = conditions.has_diagnostics,
  static = { error_icon = ' ', warn_icon = ' ', info_icon = ' ', hint_icon = ' ' },
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  update = { 'DiagnosticChanged', 'BufEnter' },
  { provider = '![', hl = { fg = 'peanut', bg = 'bg' } },
  {
    provider = function(self)
      -- 0 is just another output, we can decide to print it or not!
      return self.errors > 0 and (self.error_icon .. self.errors .. '')
    end,
    hl = { fg = 'diag_error', bg = 'bg' },
  },
  {
    provider = function(self) return self.warnings > 0 and (self.warn_icon .. self.warnings .. '') end,
    hl = { fg = 'diag_warn', bg = 'bg' },
  },
  {
    provider = function(self) return self.info > 0 and (self.info_icon .. self.info .. '') end,
    hl = { fg = 'diag_info', bg = 'bg' },
  },
  {
    provider = function(self) return self.hints > 0 and (self.hint_icon .. self.hints) end,
    hl = { fg = 'diag_hint', bg = 'bg' },
  },
  { provider = ']', hl = { fg = 'peanut', bg = 'bg' } },
}

local FileSize = {
  provider = function()
    -- stackoverflow, compute human readable file size
    local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
    fsize = (fsize < 0 and 0) or fsize
    if fsize < 1024 then return fsize .. suffix[1] end
    local i = math.floor((math.log(fsize) / math.log(1024)))
    return string.format('%.2g%s', fsize / math.pow(1024, i), suffix[i + 1])
  end,
  hl = { bg = 'bg' },
}

local Git = {
  condition = conditions.is_git_repo,
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,
  hl = { fg = 'orange' },
  { -- git branch name
    provider = function(self) return ' ' .. self.status_dict.head .. ' ' end,
    -- provider = function(self) return ' ' .. self.status_dict.head .. ' ' end,
    hl = { fg = 'peanut', bg = 'bg', bold = true, italic = true },
  },
  -- You could handle delimiters, icons and counts similar to Diagnostics
  {
    condition = function(self) return self.has_changes end,
    provider = '[',
    hl = { fg = 'peanut', bg = 'bg' },
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ('+' .. count)
    end,
    hl = { fg = 'git_add', bg = 'bg' },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ('-' .. count)
    end,
    hl = { fg = 'red', bg = 'bg' },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ('~' .. count)
    end,
    hl = { fg = 'git_change', bg = 'bg' },
  },
  {
    condition = function(self) return self.has_changes end,
    provider = ']',
    hl = { fg = 'peanut', bg = 'bg' },
  },
}

local Spell = {
  condition = function() return vim.wo.spell and vim.bo.filetype ~= 'markdown' and vim.bo.filetype ~= 'tex' end,
  provider = ' [SPELL]',
  hl = { bold = true, fg = 'orange', bg = 'bg' },
}

local FileEncoding = {
  -- condition = function() return vim.bo.fenc ~= 'utf-8' and vim.bo.fenc ~= '' end,
  condition = function() return vim.bo.fenc end,
  provider = function() return ' [' .. vim.bo.fenc:upper() .. ']' end,
  hl = {
    fg = require('heirline.utils').get_highlight('String').fg,
    bg = 'bg',
    italic = true,
    bold = true,
  },
}

local Space = { provider = ' ', hl = { bg = 'bg' } }
local Align = { provider = '%=', hl = { bg = 'bg' } }

local Statusline = {
  { ViMode },
  { FileNameBlock },
  { Space },
  { FileSize },
  { Space },
  { Git },
  -- { Space },
  { Diagnostics },
  { Align },
  { LSPMessages },
  { Align },
  { LSPActive },
  { Space },
  { FileType },
  { FileEncoding },
  { Spell },
  { Space },
  { Ruler },
  { Space },
}

require('heirline').setup {
  statusline = Statusline,
  opts = {
    colors = color,
  },
}
