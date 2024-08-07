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
local pylint = {
  prefix = 'pylint',
  lintSource = 'pylint',
  lintCommand = 'pylint --score=no ${INPUT}',
  lintStdin = false,
  lintFormats = { '%.%#:%l:%c: %t%.%#: %m' },
}
local stylua = {
  formatCommand = 'stylua --search-parent-directories --stdin-filepath ${INPUT} -',
  formatStdin = true,
  rootMarkers = { 'stylua.toml', '.stylua.toml' },
}
local flake8 = {
  prefix = 'flake8',
  lintSource = 'flake8',
  lintCommand = 'flake8 -',
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { 'stdin:%l:%c: %t%n %m' },
  rootMarkers = { 'setup.cfg', 'tox.ini', '.flake8' },
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
local shellcheck = {
  prefix = 'shellcheck',
  lintCommand = 'shellcheck --color=never --format=gcc -',
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { '-:%l:%c: %trror: %m', '-:%l:%c: %tarning: %m', '-:%l:%c: %tote: %m' },
}
local mypy = {
  prefix = 'mypy',
  lintSource = 'mypy',
  lintCommand = 'mypy --strict --strict-equality --ignore-missing-imports --show-column-numbers --hide-error-codes --hide-error-context --no-color-output --no-error-summary --no-pretty',
  lintFormats = { '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m' },
  rootMarkers = { 'mypy.ini', 'pyproject.toml', 'setup.cfg' },
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
local chktex = {
  prefix = 'chktex',
  lintSource = 'chktex',
  lintStdin = true,
  lintCommand = 'chktex -q -v0',
  lintIgnoreExitCode = true,
  lintFormats = { '%f:%l:%c:%n:%m' },
  lintSeverity = 2,
}
local latexindent = { formatCommand = 'latexindent -', formatStdin = true }
local ruff_lint = {
  prefix = 'ruff',
  lintSource = 'ruff',
  lintStdin = true,
  lintCommand = 'ruff check  --stdin-filename ${INPUT} ',
  lintFormats = { '%.%#:%l:%c: %t%n %m' },
  lintSeverity = 4,
  rootMarkers = { 'ruff.toml', 'pyproject.toml', 'setup.cfg' },
}
local ruff_format = {
  formatCommand = 'ruff format --no-cache --stdin-filename ${INPUT} ',
  formatStdin = true,
  rootMarkers = { 'ruff.toml', 'pyproject.toml', 'setup.cfg' },
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
