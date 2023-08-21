--- @diagnostic disable: unused-local
local prettier = {
  prefix = 'prettier',
  formatCanRange = true,
  formatCommand = string.format(
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
local gersemi = { prefix = 'gersemi', formatCommand = 'gersemi -', formatStdin = true }
local fourmolu = { prefix = 'fourmolu', formatCommand = 'fourmolu --stdin-input-file ${INPUT} -', formatStdin = true }
local beautysh = { prefix = 'beautysh', formatCommand = 'beautysh -', formatStdin = true }
local black = { prefix = 'black', formatCommand = 'black --fast -', formatStdin = true }
local pylint = {
  prefix = 'pylint',
  lintCommand = 'pylint --score=no ${INPUT}',
  lintStdin = false,
  lintFormats = { '%.%#:%l:%c: %t%.%#: %m' },
  rootMarkers = {},
}
local stylua = {
  prefix = 'stylua',
  formatCommand = 'stylua --search-parent-directories --stdin-filepath ${INPUT} -',
  formatStdin = true,
  rootMarkers = { 'stylua.toml', '.stylua.toml' },
}
local flake8 = {
  prefix = 'flake8',
  lintCommand = 'flake8 -',
  lintStdin = true,
  lintFormats = { 'stdin:%l:%c: %t%n %m' },
  rootMarkers = { 'setup.cfg', 'tox.ini', '.flake8' },
}
local cppcheck = {
  prefix = 'cppcheck',
  lintCommand = string.format 'cppcheck --quiet --force --enable=warning,style,performance,portability --error-exitcode=1 ${INPUT}',
  lintStdin = false,
  lintFormats = { '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m' },
  rootMarkers = { 'CmakeLists.txt', 'compile_commands.json', '.git' },
}
local shellcheck = {
  prefix = 'shellcheck',
  lintCommand = 'shellcheck --color=never --format=gcc -',
  lintStdin = true,
  lintFormats = { '-:%l:%c: %trror: %m', '-:%l:%c: %tarning: %m', '-:%l:%c: %tote: %m' },
  rootMarkers = {},
}
local mypy = {
  prefix = 'mypy',
  lintCommand = 'mypy --show-column-numbers --hide-error-codes --hide-error-context --no-color-output --no-error-summary --no-pretty',
  lintFormats = { '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m' },
  lintSource = 'mypy',
}

local langs = {
  python = { black, flake8 },
  markdown = { prettier },
  css = { prettier },
  yaml = { prettier },
  sh = { beautysh, shellcheck },
  bash = { beautysh, shellcheck },
  zsh = { beautysh, shellcheck },
  haskell = { fourmolu },
  cmake = { gersemi },
  cpp = { cppcheck },
  c = { cppcheck },
  lua = { stylua },
}

require('lspconfig').efm.setup {
  init_options = { documentFormatting = true },
  filetypes = vim.tbl_keys(langs),
  settings = {
    lintDebounce = 100,
    languages = langs,
    -- logLevel = 5,
  },
}
