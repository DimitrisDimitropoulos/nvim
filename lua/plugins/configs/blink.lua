return {
  completion = {
    accept = {
      auto_brackets = {
        kind_resolution = {
          enabled = true,
          blocked_filetypes = { 'typescriptreact', 'javascriptreact', 'vue', 'tex' },
        },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 50,
      update_delay_ms = 1,
      treesitter_highlighting = false,
      window = {
        border = vim.g.border_style,
        scrollbar = false,
      },
    },
    menu = {
      border = vim.g.border_style,
      scrollbar = false,
      draw = {
        columns = { { 'label', 'label_description', gap = 1 }, { 'kind' } },
      },
    },
    trigger = {
      show_in_snippet = true,
    },
  },
  signature = {
    enabled = true,
    window = {
      border = vim.g.border_style,
      scrollbar = false,
    },
  },
  fuzzy = {
    use_typo_resistance = true,
    use_frecency = true,
    use_proximity = true,
    sorts = {
      function(a, b)
        if a.exact ~= b.exact then
          return a.exact
        end
      end,
      'score',
      'sort_text',
    },
  },
  keymap = { preset = 'default' },
  appearance = {
    use_nvim_cmp_as_default = true,
  },
  sources = {
    default = { 'lsp', 'path', 'buffer' },
    cmdline = {},
    providers = {
      buffer = {
        min_keyword_length = 3,
      },
    },
  },
}
