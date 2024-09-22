-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local map = vim.keymap.set
    local lsp = vim.lsp.buf
    local opts = { buffer = ev.buf, silent = false }

    map("n", "<S-k>", lsp.hover, { desc = "hover" }, opts)
    map("n", "<leader>qf", lsp.code_action, { desc = "code actions", silent = true })
    map("n", "<A-f>", function() lsp.format { async = true } end, { desc = "format code" }, opts)
    map(
      "n",
      "<space>wl",
      function() print(vim.inspect(lsp.list_workspace_folders())) end,
      { desc = "list workspace folders" },
      opts
    )

    local lsp_mappings = {
      { key = "gd", cmd = "definition",              desc = "goto def" },
      { key = "gD", cmd = "declaration",             desc = "goto dec" },
      { key = "gi", cmd = "implementation",          desc = "goto impl" },
      { key = "ln", cmd = "rename",                  desc = "rename" },
      { key = "kk", cmd = "signature_help",          desc = "signature" },
      { key = "gr", cmd = "references",              desc = "references" },
      { key = "gh", cmd = "type_definition",         desc = "type definition" },
      { key = "wa", cmd = "add_workspace_folder",    desc = "add work folder" },
      { key = "wr", cmd = "remove_workspace_folder", desc = "rm work folder" },
    }
    for _, mapping in ipairs(lsp_mappings) do
      map("n", "<leader>" .. mapping.key, lsp[mapping.cmd], { desc = mapping.desc }, opts)
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("AutoFormat", { clear = true }),
      pattern = { "*tex", "*lua", "*py", "*jl", "*json", "*yaml", "*rs", "*sh" },
      -- callback = function() vim.lsp.buf.format { async = true } end,
      -- NOTE: using sync formating in order to avoid unexpected behavior, @2023-08-13 14:09:41
      callback = function() vim.lsp.buf.format() end,
      desc = "format on save",
    })

    -- NOTE: here follows the diagnostics config, @2023-08-11 14:35:14
    local signs = {
      { hl = "DiagnosticSignError", txt = "■" },
      { hl = "DiagnosticSignWarn", txt = "△" },
      { hl = "DiagnosticSignInfo", txt = "○" },
      { hl = "DiagnosticSignHint", txt = "󰨔" },
    }
    for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign.hl, { text = sign.txt, texthl = sign.hl })
    end

    vim.diagnostic.config {
      underline = true,
      virtual_text = {
        prefix = "󰋙",
        -- prefix = "󰄛",
      },
      signs = true,
      update_in_insert = false,
      float = {
        source = "always",
        border = "rounded",
        show_header = true,
      },
    }

    local diagno = {
      { key = "<leader>df", cmd = "open_float", descr = "diagnostics float" },
      { key = "[d",         cmd = "goto_prev",  descr = "diagnostics prev" },
      { key = "]d",         cmd = "goto_next",  descr = "diagnostics next" },
    }
    for _, diag in ipairs(diagno) do
      map("n", diag.key, vim.diagnostic[diag.cmd], { desc = diag.descr }, opts)
    end

    local diagnostics_active = true
    map("n", "<leader>hd", function()
      diagnostics_active = not diagnostics_active
      if diagnostics_active then
        vim.diagnostic.show()
      else
        vim.diagnostic.hide()
      end
    end, {
      desc = "toggle diagnostics",
      silent = false,
      noremap = true,
    })
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}
-- Setup language servers.
local lspconfig = require "lspconfig"

-- setup multiple servers with same default options
local servers = {
  -- "ltex",
  "julials",
  "pyright",
  "bashls",
  "neocmake",
  "clangd",
  "ruff_lsp",
  "jsonls",
}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

-- NOTE: with the following config it can replace null-ls and vimtex, @2023-08-11 15:29:27
lspconfig.texlab.setup {
  capabilities = capabilities,
  settings = {
    texlab = {
      build = {
        -- onSave = true,
        args = {
          "-pdf",
          "-lualatex",
          "-interaction=nonstopmode",
          "-synctex=1",
          "%f",
        },
      },
      forwardSearch = {
        executable = "zathura",
        args = { "--synctex-forward", "%l:1:%f", "%p" },
      },
      chktex = {
        onOpenAndSave = true,
        onEdit = true,
      },
      diagnosticsDelay = 200,
      latexFormatter = "latexindent",
      latexindent = {
        ["local"] = nil, -- local is a reserved keyword
        modifyLineBreaks = false,
      },
      bibtexFormatter = "latexindent",
      formatterLineLength = 80,
    },
  },
}

lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  },
}

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
  json = { formatter = prettier },
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

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      hint = { enable = true }, -- only for nvim 10.0
      diagnostics = {
        globals = { "vim" },
        -- disable = { "different-requires" },
      },
      format = {
        enable = true,
      },
    },
  },
}
