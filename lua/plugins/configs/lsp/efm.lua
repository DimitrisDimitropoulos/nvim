local efmls = require "efmls-configs"
efmls.init { init_options = { documentFormatting = true, codeAction = true } }
local black = require "efmls-configs.formatters.black"
local cppcheck = {
  prefix = "cppcheck",
  lintCommand = string.format "cppcheck --quiet --force --enable=warning,style,performance,portability --error-exitcode=1 ${INPUT}",
  lintStdin = false,
  lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
  rootMarkers = { "CmakeLists.txt", "compile_commands.json", ".git" },
}
-- local mypy = {
--   prefix = "mypy",
--   lintCommand = "mypy --show-column-numbers ${INPUT}",
--   lintStdin = true,
--   lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
--   rootMarkers = { "setup.py", "setup.cfg", "pyproject.toml", ".git" },
-- }
local flake8 = require "efmls-configs.linters.flake8"
local prettier = require "efmls-configs.formatters.prettier"
local rustfmt = require "efmls-configs.formatters.rustfmt"
local shellcheck = require "efmls-configs.linters.shellcheck"
local stylua = require "efmls-configs.formatters.stylua"
local gersemi = { formatCommand = "gersemi -", formatStdin = true }
local fourmolu = { formatCommand = "fourmolu --stdin-input-file -", formatStdin = true }
local beautysh = { formatCommand = "beautysh -", formatStdin = true }

efmls.setup {
  markdown = { formatter = prettier },
  -- json = { formatter = prettier },
  css = { formatter = prettier },
  yaml = { formatter = prettier },
  lua = { formatter = stylua },
  sh = { linter = shellcheck, formatter = beautysh },
  bash = { linter = shellcheck, formatter = beautysh },
  zsh = { formatter = beautysh },
  rust = { formatter = rustfmt },
  python = { formatter = black, linter = flake8 },
  cpp = { linter = cppcheck },
  c = { linter = cppcheck },
  cmake = { formatter = gersemi },
  haskell = { formatter = fourmolu },
}
-- local command = string.format "rustfmt --emit=stdout"
-- -- if plenary is available, we can try to read the Rust edition from Cargo.toml
-- -- source: https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Source-specific-Configuration#rustfmt
-- local ok, Path = pcall(require, "plenary.path")
-- if ok then
--   local util = require "lspconfig.util"
--   local root = util.root_pattern "Cargo.toml"(vim.loop.cwd())
--   if root then
--     local cargo_toml = Path:new(root .. "/" .. "Cargo.toml")
--     if cargo_toml:exists() and cargo_toml:is_file() then
--       for _, line in ipairs(cargo_toml:readlines()) do
--         local edition = line:match [[^edition%s*=%s*%"(%d+)%"]]
--         if edition then command = string.format("%s --edition=%s", command, edition) end
--       end
--     end
--   end
-- end
-- local rustfmt = {
--   formatCommand = command,
--   formatStdin = true,
-- }
-- local prettier = {
--   formatCanRange = true,
--   formatCommand = string.format(
--     "prettier --stdin --stdin-filepath ${INPUT} ${--range-start:charStart} "
--       .. "${--range-end:charEnd} ${--tab-width:tabSize} ${--use-tabs:!insertSpaces}"
--   ),
--   formatStdin = true,
--   rootMarkers = {
--     ".prettierrc",
--     ".prettierrc.json",
--     ".prettierrc.js",
--     ".prettierrc.yml",
--     ".prettierrc.yaml",
--     ".prettierrc.json5",
--     ".prettierrc.mjs",
--     ".prettierrc.cjs",
--     ".prettierrc.toml",
--   },
-- }
-- local gersemi = { formatCommand = "gersemi -", formatStdin = true }
-- local fourmolu = { formatCommand = "fourmolu --stdin-input-file -", formatStdin = true }
-- local beautysh = { formatCommand = "beautysh -", formatStdin = true }
-- local stylua = {
--   formatCanRange = true,
--   formatCommand = string.format(
--     "stylua ${--indent-width:tabSize} ${--range-start:charStart} " .. "${--range-end:charEnd} --color Never -"
--   ),
--   formatStdin = true,
--   rootMarkers = { "stylua.toml", ".stylua.toml" },
-- }
-- local black = {
--   formatCommand = string.format "black --no-color --quiet -q ${INPUT}",
--   formatStdin = true,
-- }
-- local mypy = {
--   lintCommand = string.format "mypy --show-column-numbers ${INPUT}",
--   lintStdin = true,
--   lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
-- }
-- lspconfig.efm.setup {
--   init_options = { documentFormatting = true, codeAction = true },
--   settings = {
--     languages = {
--       python = { { mypy }, { black } },
--       lua = { { stylua } },
--       sh = { { beautysh } },
--       bash = { { beautysh } },
--       zsh = { { beautysh } },
--       haskel = { { fourmolu } },
--       cmake = { { gersemi } },
--       markdown = { { prettier } },
--       json = { { prettier } },
--       css = { { prettier } },
--       yaml = { { prettier } },
--       rust = { { rustfmt } },
--     },
--   },
-- }
