require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "lua",
    "json",
    "yaml",
    "toml",
    "css",
    "cpp",
    "c",
    "rust",
    "python",
    "bash",
    "julia",
    "latex",
    "bibtex",
    "comment",
  },
  highlight = {
    enable = true,
    use_languagetree = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = true },
    smart_rename = {
      enarle = true,
      keymaps = {
        smart_rename = "grr",
      },
    },
  },
}

-- hl groups for the comments
-- NOTE: Treesitter is prone to breaking changes, @2023-07-24 17:05:41
local comms_hl = { "@text.todo", "@text.danger", "@text.warning", "@text.note" }
for _, hl in ipairs(comms_hl) do
  vim.api.nvim_set_hl(0, hl, { bold = true, underline = true })
end
