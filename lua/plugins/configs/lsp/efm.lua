--- @diagnostic disable: unused-local
local prettier = {
  prefix = 'prettier',
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
local gersemi = { prefix = 'gersemi', formatCommand = 'gersemi -', formatStdin = true }
local fourmolu = { prefix = 'fourmolu', formatCommand = 'fourmolu --stdin-input-file ${INPUT} -', formatStdin = true }
local beautysh = { prefix = 'beautysh', formatCommand = 'beautysh -', formatStdin = true }
local black = { prefix = 'black', formatCommand = 'black --fast -', formatStdin = true }
local pylint = {
  prefix = 'pylint',
  lintSource = 'pylint',
  lintCommand = 'pylint --score=no ${INPUT}',
  lintStdin = false,
  lintFormats = { '%.%#:%l:%c: %t%.%#: %m' },
}
local stylua = {
  prefix = 'stylua',
  formatCommand = 'stylua --search-parent-directories --stdin-filepath ${INPUT} -',
  formatStdin = true,
  rootMarkers = { 'stylua.toml', '.stylua.toml' },
}
local flake8 = {
  prefix = 'flake8',
  lintSource = 'flake8',
  lintCommand = 'flake8 -',
  lintStdin = true,
  lintFormats = { 'stdin:%l:%c: %t%n %m' },
  rootMarkers = { 'setup.cfg', 'tox.ini', '.flake8' },
}
local cppcheck = {
  prefix = 'cppcheck',
  lintSource = 'cppcheck',
  lintCommand = 'cppcheck --quiet --force --enable=warning,style,performance,portability --error-exitcode=1 ${INPUT}',
  lintStdin = false,
  lintFormats = { '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m' },
  rootMarkers = { 'CmakeLists.txt', 'compile_commands.json', '.git' },
}
local shellcheck = {
  prefix = 'shellcheck',
  lintCommand = 'shellcheck --color=never --format=gcc -',
  lintStdin = true,
  lintFormats = { '-:%l:%c: %trror: %m', '-:%l:%c: %tarning: %m', '-:%l:%c: %tote: %m' },
}
local mypy = {
  prefix = 'mypy',
  lintSource = 'mypy',
  lintCommand = 'mypy --show-column-numbers --hide-error-codes --hide-error-context --no-color-output --no-error-summary --no-pretty',
  lintFormats = { '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m' },
  rootMarkers = { 'mypy.ini', 'pyproject.toml', 'setup.cfg' },
}
local jq_lint = {
  prefix = 'jq',
  lintSource = 'jq',
  lintCommand = 'jq',
  lintStdin = true,
  lintOffset = 1,
  lintFormats = { '%m at line %l, column %c' },
}
local jq_format = {
  prefix = 'jq',
  formatCommand = 'jq',
  formatStdin = true,
}
local shfmt = {
  prefix = 'shfmt',
  formatCommand = 'shfmt -filename ${INPUT} -',
  formatStdin = true,
}

local selene = {
  prefix = 'selene',
  lintSource = 'selene',
  lintStdin = true,
  lintCommand = 'selene --display-style quiet -',
  lintFormats = { '%f:%l:%c: %trror%m', '%f:%l:%c: %tarning%m', '%f:%l:%c: %tote%m' },
}

local langs = {
  json = { jq_lint, jq_format },
  python = { black, mypy, flake8 },
  markdown = { prettier },
  css = { prettier },
  yaml = { prettier },
  sh = { shfmt },
  bash = { shfmt },
  zsh = { beautysh },
  haskell = { fourmolu },
  cmake = { gersemi },
  cpp = { cppcheck },
  c = { cppcheck },
  lua = { stylua },
}

require('lspconfig').efm.setup {
  init_options = {
    documentFormatting = true,--[[ , codeAction = true ]]
  },
  filetypes = vim.tbl_keys(langs),
  settings = {
    lintDebounce = 100,
    languages = langs,
    -- logLevel = 5,
  },
}
