vim.cmd 'highlight clear'
vim.g.colors_name = 'melange'

local base = {
  bg = '#292522',
  float = '#34302C',
  sel = '#403A36',
  ui = '#867462',
  com = '#C1A78E',
  fg = '#ECE1D7',
}

local bright = {
  red = '#F8907D',
  yellow = '#E8BD6A',
  green = '#7FBF95',
  cyan = '#71BCC2',
  blue = '#ABB3EB',
  magenta = '#E7A5D7',
}

local accent = {
  red = '#D49184',
  yellow = '#C3A365',
  green = '#7BAC8B',
  cyan = '#89B3B9',
  blue = '#A0A7D7',
  magenta = '#D99FCB',
}

local deep = {
  red = '#7D2A2F',
  yellow = '#8B7449',
  green = '#233524',
  cyan = '#253333',
  blue = '#273142',
  magenta = '#422741',
}

local function set(name, spec)
  vim.api.nvim_set_hl(0, name, type(spec) == 'string' and { link = spec } or spec)
end

local core = {
  Normal = { fg = base.fg, bg = base.bg },
  NormalFloat = { bg = base.float },
  FloatTitle = { fg = accent.yellow, bg = base.float },
  FloatFooter = { fg = accent.yellow, bg = base.float },

  ColorColumn = { bg = base.float },
  CursorColumn = 'ColorColumn',
  CursorLine = 'ColorColumn',
  WinSeparator = { fg = base.ui },

  LineNr = { fg = base.ui },
  CursorLineNr = { fg = accent.yellow },
  Folded = { fg = base.com, bg = deep.cyan },
  FoldColumn = 'LineNr',
  SignColumn = 'LineNr',

  -- MiniPickBorder = {},
  -- MiniPickBorderBusy = {},
  -- MiniPickBorderText = {},
  -- MiniPickCursor = {},
  MiniPickIconDirectory = { fg = bright.cyan },
  -- MiniPickIconFile = {},
  -- MiniPickHeader = {},
  MiniPickMatchCurrent = { bg = accent.green, fg = base.bg, bold = true },
  -- MiniPickMatchMarked = {},
  MiniPickMatchRanges = { bg = accent.magenta, fg = base.bg, bold = true, underline = true },
  -- MiniPickNormal = {},
  -- MiniPickPreviewLine = {},
  -- MiniPickPreviewRegion = {},
  MiniPickPrompt = { fg = bright.yellow, bg = accent.float, bold = true },
  -- MiniPickPromptCaret = {},
  -- MiniPickPromptPrefix = {},

  Pmenu = 'NormalFloat',
  PmenuSel = { bg = base.sel },
  PmenuThumb = 'PmenuSel',
  PmenuMatch = { fg = bright.yellow, bold = true, bg = base.float },
  PmenuMatchSel = { fg = bright.yellow, bold = true, bg = base.sel },
  ComplMatchIns = { fg = base.com },
  WildMenu = 'NormalFloat',

  StatusLine = 'NormalFloat',
  StatusLineNC = { fg = base.com, bg = base.float },
  TabLine = 'StatusLineNC',
  TabLineFill = 'StatusLine',
  TabLineSel = { bg = base.float, bold = true },

  CurSearch = { fg = base.bg, bg = bright.yellow, bold = true },
  MatchParen = { reverse = true, bold = true },
  Search = { fg = base.bg, bg = deep.yellow, bold = true },
  Substitute = { bg = deep.red, bold = true },
  Visual = { bg = base.sel },

  Conceal = { fg = base.com },
  Whitespace = { fg = base.ui },
  NonText = 'Whitespace',
  SpecialKey = 'Whitespace',

  Directory = { fg = accent.green },
  Title = { fg = accent.yellow, bold = true },
  ErrorMsg = { bg = deep.red },
  ModeMsg = { fg = base.com },
  MoreMsg = { fg = accent.green, bold = true },
  WarningMsg = { fg = accent.red },
  Question = 'MoreMsg',

  QuickFixLine = 'PmenuMatch',
  qfFileName = 'Directory',

  DiffAdd = { bg = deep.green },
  DiffChange = { bg = deep.magenta },
  DiffDelete = { fg = base.com, bg = deep.red },
  DiffText = 'DiffAdd',
  DiffAdded = 'DiffAdd',
  DiffRemoved = 'DiffDelete',

  SpellBad = { fg = accent.red, undercurl = true },
  SpellCap = { fg = accent.blue, undercurl = true },
  SpellLocal = { fg = accent.yellow, undercurl = true },
  SpellRare = { fg = bright.yellow, undercurl = true },
}

local syntax = {
  Comment = { fg = base.com, italic = true },
  Identifier = { fg = base.fg },
  Function = { fg = bright.yellow },
  Constant = { fg = accent.magenta },
  String = { fg = bright.blue, italic = true },
  Character = { fg = accent.blue },
  Number = { fg = bright.magenta },
  Boolean = 'Number',

  Statement = { fg = accent.yellow },
  Operator = { fg = bright.red },
  PreProc = { fg = bright.green },
  Type = { fg = accent.cyan },
  Special = { fg = bright.yellow },
  Delimiter = { fg = deep.yellow },

  Underlined = { underline = true },
  Bold = { bold = true },
  Italic = { italic = true },

  Ignore = { fg = base.ui },
  Error = { bg = deep.red },
  Todo = { fg = base.com, bold = true },
}

local treesitter = {
  ['@variable'] = 'Identifier',
  ['@variable.builtin'] = '@string.special.symbol',
  ['@constant'] = 'Identifier',
  ['@constant.builtin'] = 'Constant',
  ['@constant.macro'] = 'Constant',

  ['@module'] = 'Identifier',
  ['@module.builtin'] = '@module',
  ['@label'] = { fg = bright.cyan },

  ['@string.documentation'] = { fg = bright.blue, nocombine = true },
  ['@string.escape'] = { fg = accent.blue },
  ['@string.regexp'] = { fg = bright.blue },
  ['@string.special'] = { fg = bright.cyan },
  ['@string.special.symbol'] = { fg = base.fg, italic = true },
  ['@string.special.path'] = 'Directory',
  ['@string.special.url'] = { fg = accent.blue },

  ['@type.builtin'] = '@type',
  ['@function.builtin'] = '@function',
  ['@function.macro'] = '@function',
  ['@constructor'] = '@function',

  ['@keyword.function'] = 'PreProc',
  ['@keyword.import'] = 'PreProc',
  ['@keyword.directive'] = 'PreProc',

  ['@punctuation.delimiter'] = { fg = accent.red },

  ['@comment.documentation'] = { fg = base.com, nocombine = true },
  ['@comment.error'] = 'Todo',
  ['@comment.note'] = 'Todo',
  ['@comment.todo'] = 'Todo',
  ['@comment.warning'] = 'Todo',

  ['@markup.italic'] = { italic = true },
  ['@markup.strong'] = { bold = true },
  ['@markup.strikethrough'] = { strikethrough = true },
  ['@markup.underline'] = { underline = true },
  ['@markup.heading'] = 'Title',
  ['@markup.heading.2'] = { fg = bright.yellow, bold = true },
  ['@markup.heading.3'] = { fg = bright.green, bold = true },
  ['@markup.heading.5'] = '@markup.heading.2',
  ['@markup.heading.6'] = '@markup.heading.3',
  ['@markup.quote'] = 'Comment',
  ['@markup.math'] = '@markup.raw',
  ['@markup.link'] = { underline = true },
  ['@markup.link.url'] = '@string.special.url',
  ['@markup.raw'] = '@string.special',
  ['@markup.raw.block'] = { fg = base.com },
  ['@markup.list'] = 'Delimiter',

  ['@diff.plus'] = 'DiffAdd',
  ['@diff.minus'] = 'DiffDelete',
  ['@diff.delta'] = 'DiffChange',

  ['@tag.attribute'] = '@label',
  ['@tag.delimiter'] = 'Delimiter',
}

local diagnostic_colors = {
  Error = accent.red,
  Warn = bright.yellow,
  Info = accent.blue,
  Hint = accent.cyan,
  Ok = accent.green,
}

for level, color in pairs(diagnostic_colors) do
  set('Diagnostic' .. level, { fg = color })
  set('DiagnosticUnderline' .. level, { undercurl = true, sp = color })
end

local diagnostics = {
  DiagnosticDeprecated = 'DiagnosticUnderlineError',
  DiagnosticUnnecessary = { undercurl = true, sp = base.com },
}

local lsp = {
  LspReferenceText = { bg = base.sel, underline = false },
  ['@lsp.type.enumMember'] = 'Constant',
  ['@lsp.type.macro'] = {},
  ['@lsp.type.namespace'] = 'Directory',
  ['@lsp.type.parameter'] = { fg = base.fg, bold = true },
  ['@lsp.typemod.comment.documentation'] = '@comment.documentation',
  ['@lsp.typemod.variable.globalScope'] = { italic = true },
}

local plugins = {
  netrwClassify = 'Delimiter',
  netrwTreeBar = 'Delimiter',
  netrwExe = { fg = accent.red },
  netrwSymLink = { fg = accent.magenta },

  markdownCode = '@markup.raw',
  markdownCodeBlock = '@markup.raw.block',

  GitSignsAdd = { fg = accent.green },
  GitSignsChange = { fg = accent.magenta },
  GitSignsDelete = { fg = accent.red },
  GitSignsCurrentLineBlame = { fg = accent.blue },
}

for _, groups in ipairs { core, syntax, treesitter, diagnostics, lsp, plugins } do
  for name, spec in pairs(groups) do
    set(name, spec)
  end
end

local terminal = {
  base.float,
  accent.red,
  accent.green,
  accent.yellow,
  accent.blue,
  accent.magenta,
  accent.cyan,
  base.com,
  base.ui,
  bright.red,
  bright.green,
  bright.yellow,
  bright.blue,
  bright.magenta,
  bright.cyan,
  base.fg,
}

for i, color in ipairs(terminal) do
  vim.g['terminal_color_' .. (i - 1)] = color
end
