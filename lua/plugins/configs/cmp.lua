local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
  return
end
local ls = require 'luasnip'

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

local function border(hl_name)
  return {
    { '╭', hl_name },
    { '─', hl_name },
    { '╮', hl_name },
    { '│', hl_name },
    { '╯', hl_name },
    { '─', hl_name },
    { '╰', hl_name },
    { '│', hl_name },
  }
end

cmp.setup {

  window = {
    completion = {
      winhighlight = 'Normal:CmpPmenu,Search:PmenuSel',
      scrollbar = false,
      border = border 'CmpDocBorder',
    },
    documentation = { border = border 'CmpDocBorder', winhighlight = 'Normal:CmpDoc' },
  },

  snippet = {
    expand = function(args)
      ls.lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert {
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<A-u>'] = cmp.mapping.scroll_docs(-4),
    ['<A-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ['<A-j>'] = cmp.mapping(function(fallback)
      if ls.expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<A-k>'] = cmp.mapping(function(fallback)
      if ls.jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
      else
        fallback()
      end
    end, { 'i', 's' }),
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

local hl = vim.api.nvim_set_hl
hl(0, 'PeanutHLGroup', { fg = '#ffd899' })
hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#ffd899', bold = true })
hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
hl(0, 'CmpItemKindMethod', { bg = 'NONE', fg = '#b3de81' })
hl(0, 'CmpItemKindStruct', { link = 'CmpItemKindMethod' })
hl(0, 'CmpItemKindField', { link = 'CmpItemKindMethod' })
hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#9CDCFE' })
hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
hl(0, 'CmpItemKindText', { bg = 'NONE', fg = '#D4D4D4' })
hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindText' })
hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindText' })
hl(0, 'CmpItemKindKeyword', { link = 'VioletHLGroup' })
hl(0, 'CmpItemKindSnippet', { link = 'VioletHLGroup' })
