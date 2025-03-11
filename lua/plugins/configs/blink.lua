return {
  completion = {
    list = {
      max_items = 20,
      selection = {
        auto_insert = false,
      },
    },
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
      update_delay_ms = 50,
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
  keymap = {
    preset = 'default',
    ['<C-y>'] = { 'select_and_accept', 'fallback' },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
  },
  cmdline = {
    sources = {},
  },
  sources = {
    default = { 'lsp', 'path', 'buffer' },
    providers = {
      buffer = {
        min_keyword_length = 3,
      },
    },
  },
}
