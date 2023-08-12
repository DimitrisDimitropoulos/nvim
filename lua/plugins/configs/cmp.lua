local cmp = require "cmp"
local ls = require "luasnip"
local lspkind = require "lspkind"

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

cmp.setup {

  window = {
    completion = {
      winhighlight = "Normal:CmpPmenu,Search:PmenuSel",
      scrollbar = false,
      border = border "CmpDocBorder",
    },
    documentation = {
      border = border "CmpDocBorder",
      winhighlight = "Normal:CmpDoc",
    },
  },

  snippet = {
    expand = function(args) ls.lsp_expand(args.body) end,
  },

  mapping = cmp.mapping.preset.insert {
    ["<Up>"] = cmp.mapping.select_prev_item(),
    ["<Down>"] = cmp.mapping.select_next_item(),
    ["<A-d>"] = cmp.mapping.scroll_docs(-4),
    ["<A-u>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ["<A-j>"] = cmp.mapping(function(fallback)
      if ls.expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<A-k>"] = cmp.mapping(function(fallback)
      if ls.jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },

  sources = cmp.config.sources {
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "buffer",  max_item_count = 3 },
    { name = "nvim_lua" },
    { name = "path" },
    -- { name = "copilot" },
    -- { name = "spell" },
  },

  formatting = {
    format = lspkind.cmp_format {
      mode = "symbol_text",
      with_text = true,
      maxwidth = 50,
      ellipsis_char = "...",
      -- menu = {
      --   buffer = "[buf]",
      --   nvim_lsp = "[LSP]",
      --   nvim_lua = "[api]",
      --   path = "[path]",
      --   luasnip = "[snip]",
      --   gh_issues = "[issues]",
      --   tn = "[TabNine]",
      --   eruby = "[erb]",
      -- },
    },
  },

  sorting = {
    -- TODO: Would be cool to add stuff like "See variable names before method names" in rust, or something like that.
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find "^_+"
        local _, entry2_under = entry2.completion_item.label:find "^_+"
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
}

-- -- Copilot cmp source
-- vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
-- -- lspkind.lua
-- local Lspkind = require("lspkind")
-- Lspkind.init({
--   symbol_map = {
--     Copilot = "",
--   },
-- })
