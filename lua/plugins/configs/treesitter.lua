require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "tsx",
    "html",
    "json",
    "yaml",
    "toml",
    "css",
    "typescript",
    "javascript",
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
