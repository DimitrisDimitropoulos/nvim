local luasnip_ok, ls = pcall(require, 'luasnip')
if not luasnip_ok then
  return
end

local types = require 'luasnip.util.types'

ls.config.set_config {
  updateevents = 'TextChanged,TextChangedI',
  delete_check_events = 'TextChanged',
  enable_autosnippets = false,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { '●', 'PortalOrange' } },
        hl_mode = 'combine',
      },
    },
    [types.insertNode] = {
      active = {
        virt_text = { { '<...>', 'PortalBlue' } },
        hl_mode = 'combine',
      },
    },
  },
}

local function cicle(dir)
  if ls.choice_active() then
    ls.change_choice(dir)
  end
end
vim.keymap.set({ 'i', 's' }, '<A-l>', function()
  cicle(1)
end)
vim.keymap.set({ 'i', 's' }, '<A-h>', function()
  cicle(-1)
end)
vim.keymap.set({ 'i', 's' }, '<A-j>', function()
  ls.jump(1)
end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<A-k>', function()
  ls.jump(-1)
end, { silent = true })

require('luasnip.loaders.from_vscode').lazy_load()
-- require('luasnip.loaders.from_vscode').lazy_load { paths = '~/.config/nvim/snippets/json_snippets/' or '' }
require('luasnip.loaders.from_vscode').lazy_load { paths = './snippets/json_snippets' or '' }
require('luasnip.loaders.from_lua').lazy_load()
-- require('luasnip.loaders.from_lua').lazy_load { paths = '~/.config/nvim/snippets/lua_snippets/' or '' }
require('luasnip.loaders.from_lua').lazy_load { paths = './snippets/lua_snippets' or '' }

vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    if ls.session.current_nodes[vim.api.nvim_get_current_buf()] and not ls.session.jump_active then
      ls.unlink_current()
    end
  end,
})
