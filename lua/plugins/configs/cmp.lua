local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
  return
end

local kind_icons = {
  Text = '',
  Method = '󰆧',
  Function = '󰊕',
  Constructor = '',
  Field = '󰇽',
  Variable = '󰀫',
  Class = '󰠱',
  Interface = '',
  Module = '',
  Property = '󰜢',
  Unit = '',
  Value = '󰎠',
  Enum = '',
  Keyword = '󰌋',
  Snippet = '',
  Color = '󰏘',
  File = '󰈙',
  Reference = '',
  Folder = '󰉋',
  EnumMember = '',
  Constant = '󰏿',
  Struct = '󰙅',
  Event = '',
  Operator = '󰆕',
  TypeParameter = '󰅲',
}

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

  formatting = {
    format = function(_, vim_item)
      vim_item.kind = (kind_icons[vim_item.kind] or '') .. ' ' .. vim_item.kind
      return vim_item
    end,
  },

  sources = cmp.config.sources {
    { name = 'luasnip', priority = 9 },
    { name = 'nvim_lsp', priority = 9 },
    { name = 'nvim_lsp_signature_help', priority = 9 },
    -- { name = 'nvim_lua', priority = 9 },
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
  CmpItemKindValue = '@constant',
  CmpItemKindUnit = '@constant',
  CmpItemKindTypeParameter = '@variable.parameter',
  CmpItemKindText = '@text',
  CmpItemKindStruct = { fg = '#b3de81' },
  CmpItemKindSnippet = { fg = '#d4bfff' },
  CmpItemKindReference = '@type',
  CmpItemKindProperty = '@property',
  CmpItemKindOperator = '@operator',
  CmpItemKindModule = '@namespace',
  CmpItemKindMethod = { fg = '#b3de81' },
  CmpItemKindKeyword = '@keyword',
  CmpItemKindInterface = '@type',
  CmpItemKindFunction = '@function',
  CmpItemKindFolder = '@string.special.path',
  CmpItemKindFile = '@string.special.path',
  CmpItemKindField = { fg = '#b3de81' },
  CmpItemKindEvent = '@type',
  CmpItemKindEnumMember = '@field',
  CmpItemKindEnum = '@type',
  CmpItemKindConstructor = '@constructor',
  CmpItemKindConstant = '@constant',
  CmpItemKindColor = '@constant',
  CmpItemKindClass = '@type',
} do
  if type(attr) == 'table' then
    vim.api.nvim_set_hl(0, name, attr)
  end
  if type(attr) == 'string' then
    vim.api.nvim_set_hl(0, name, { link = attr })
  end
end
