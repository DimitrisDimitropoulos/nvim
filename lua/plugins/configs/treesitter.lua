require('nvim-treesitter.configs').setup {
  ensure_installed = { 'lua', 'c', 'vimdoc', 'markdown', 'markdown_inline' },
  highlight = {
    enable = true,
    use_languagetree = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = false },
  refactor = { highlight_definitions = { enable = false }, highlight_current_scope = { enable = false } },
  autopairs = { enable = false },
}
