local guard_ok, guard = pcall(require, "guard")
if not guard_ok then return end
local ft = require "guard.filetype"

ft("lua"):fmt "stylua"

local prettier_fts = { "json", "yaml", "markdown", "css", "scss" }
for _, fts in ipairs(prettier_fts) do
  ft(fts):fmt "prettier"
end

local shellcheck_fts = { "sh", "bash" }
for _, fts in ipairs(shellcheck_fts) do
  ft(fts):lint "shellcheck"
end

local beautysh_fts = { "sh", "bash", "zsh" }
for _, fts in ipairs(beautysh_fts) do
  ft(fts):fmt {
    cmd = "beautysh",
    args = { "-" },
  }
end

ft("python"):fmt "black"

ft("rust"):fmt "rustfmt"

ft("cmake"):fmt {
  cmd = "gersemi",
  args = { "-" },
  stdin = true,
}

ft("haskell"):fmt {
  cmd = "fourmolu",
  args = { "--stdin-input-file", "-" },
  stdin = true,
}

-- Call setup() LAST!
guard.setup {
  -- the only options for the setup function
  fmt_on_save = true,
  -- Use lsp if no formatter was defined for this filetype
  lsp_as_default_formatter = true,
}
