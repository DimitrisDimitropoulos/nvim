local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
  return
end

cmp.setup {

  window = {
    documentation = { border = vim.g.border_style },
    completion = { scrollbar = false, border = vim.g.border_style },
  },

  mapping = cmp.mapping.preset.insert {
    ['<A-u>'] = cmp.mapping.scroll_docs(-4),
    ['<A-d>'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
  },

  sources = cmp.config.sources {
    -- { name = 'luasnip', priority = 9 },
    { name = 'nvim_lsp', priority = 9 },
    { name = 'path', priority = 5 },
    { name = 'buffer', keyword_length = 2, max_item_count = 3, priority = 1 },
  },

  sorting = {
    comparators = {
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.kind,
      cmp.config.compare.recently_used,
      function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find '^_+'
        local _, entry2_under = entry2.completion_item.label:find '^_+'
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,
      cmp.config.compare.sort_text,
      cmp.config.compare.order,
    },
  },
}

for name, attr in pairs {
  CmpItemAbbrMatch = { fg = '#ffd899', bold = true },
  CmpItemAbbrMatchFuzzy = { fg = '#ffd899', bold = true },
  CmpItemKindVariable = { fg = '#9CDCFE' },
  CmpItemKindStruct = { fg = '#b3de81' },
  CmpItemKindSnippet = { fg = '#d4bfff' },
  CmpItemKindMethod = { fg = '#b3de81' },
  CmpItemKindField = { fg = '#b3de81' },
} do
  vim.api.nvim_set_hl(0, name, attr)
end
