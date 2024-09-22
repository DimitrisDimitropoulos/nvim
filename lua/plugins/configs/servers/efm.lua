---@diagnostic disable: unused-local
local prettier = {
  formatCanRange = true,
  formatCommand = (
    'prettier --stdin --stdin-filepath ${INPUT} ${--range-start:charStart} '
    .. '${--range-end:charEnd} ${--tab-width:tabSize} ${--use-tabs:!insertSpaces}'
  ),
  formatStdin = true,
  rootMarkers = {
    '.prettierrc',
    '.prettierrc.json',
    '.prettierrc.js',
    '.prettierrc.yml',
    '.prettierrc.yaml',
    '.prettierrc.json5',
    '.prettierrc.mjs',
    '.prettierrc.cjs',
    '.prettierrc.toml',
  },
}
local gersemi = { formatCommand = 'gersemi -', formatStdin = true }
local fourmolu = { formatCommand = 'fourmolu --stdin-input-file ${INPUT} -', formatStdin = true }
local beautysh = { formatCommand = 'beautysh -', formatStdin = true }
local black = { formatCommand = 'black --fast -', formatStdin = true }
local stylua = {
  formatCommand = 'stylua --search-parent-directories --stdin-filepath ${INPUT} -',
  formatStdin = true,
  rootMarkers = { 'stylua.toml', '.stylua.toml' },
}
local cppcheck = {
  prefix = 'cppcheck',
  lintSource = 'cppcheck',
  lintCommand = 'cppcheck --quiet --force --enable=warning,style,performance,portability --error-exitcode=1 ${INPUT}',
  lintIgnoreExitCode = true,
  lintStdin = false,
  lintFormats = { '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m' },
  rootMarkers = { 'CmakeLists.txt', 'compile_commands.json', '.git' },
}
local jq_lint = {
  prefix = 'jq',
  lintSource = 'jq',
  lintCommand = 'jq',
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintOffset = 1,
  lintFormats = { '%m at line %l, column %c' },
}
local jq_format = { formatCommand = 'jq', formatStdin = true }
local shfmt = { formatCommand = 'shfmt -filename ${INPUT} -', formatStdin = true }
local selene = {
  prefix = 'selene',
  lintSource = 'selene',
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintCommand = 'selene --display-style quiet -',
  lintFormats = { '%f:%l:%c: %trror%m', '%f:%l:%c: %tarning%m', '%f:%l:%c: %tote%m' },
}
local luacheck = {
  prefix = 'luacheck',
  lintSource = 'luacheck',
  lintStdin = true,
  lintCommand = 'luacheck --codes --no-color --quiet -',
  lintIgnoreExitCode = true,
  lintFormats = { '%.%#:%l:%c: (%t%n) %m' },
  rootMarkers = { '.luacheckrc' },
}
local fish_indent = { formatCommand = 'fish_indent', formatStdin = true }

local langs = {
  json = { jq_lint, jq_format },
  markdown = { prettier },
  css = { prettier },
  yaml = { prettier },
  sh = { shfmt },
  bash = { shfmt },
  zsh = { beautysh },
  haskell = { fourmolu },
  cpp = { cppcheck },
  c = { cppcheck },
  lua = { stylua },
  fish = { fish_indent },
}

require('lspconfig').efm.setup {
  init_options = { documentFormatting = true },
  filetypes = vim.tbl_keys(langs),
  settings = { lintDebounce = 100, languages = langs, logLevel = 1 },
}
