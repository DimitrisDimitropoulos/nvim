local M = {}

M.luasnip = function(opts)
  require('luasnip').config.set_config(opts)
  local ls = require 'luasnip'

  vim.keymap.set({ 'i', 's' }, '<A-l>', function()
    if ls.choice_active() then ls.change_choice(1) end
  end)
  vim.keymap.set({ 'i', 's' }, '<A-h>', function()
    if ls.choice_active() then ls.change_choice(-1) end
  end)

  -- vscode format
  -- require("luasnip.loaders.from_vscode").lazy_load { paths = { "./snippets" } }
  require('luasnip.loaders.from_vscode').lazy_load()
  require('luasnip.loaders.from_vscode').lazy_load {
    paths = '~/.config/nvim/snippets/json_snippets/' or '',
  }

  -- -- snipmate format
  -- require("luasnip.loaders.from_snipmate").load()
  -- require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

  -- lua format
  require('luasnip.loaders.from_lua').load()
  require('luasnip.loaders.from_lua').lazy_load {
    paths = '~/.config/nvim/snippets/lua_snippets/' or '',
  }

  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
      if
        require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
      then
        require('luasnip').unlink_current()
      end
    end,
  })
end

return M
