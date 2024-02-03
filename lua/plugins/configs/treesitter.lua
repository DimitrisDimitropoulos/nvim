require('nvim-treesitter.configs').setup {
  ensure_installed = { 'lua', 'cpp', 'c', 'bash' },
  highlight = {
    enable = true,
    use_languagetree = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = false },
  refactor = { highlight_definitions = { enable = false }, highlight_current_scope = { enable = false } },
  autopairs = { enable = false },
}

-- hl groups for the comments
-- NOTE: Treesitter is prone to breaking changes, @2023-07-24 17:05:41
local comms_hl = { '@text.todo', '@text.danger', '@text.warning', '@text.note' }
for _, hl in ipairs(comms_hl) do
  vim.api.nvim_set_hl(0, hl, { bold = true, underline = true })
end

vim.api.nvim_set_hl(0, 'VioletHLGroup', { fg = '#d4bfff' })
vim.api.nvim_set_hl(0, '@lsp.typemod.keyword', { link = 'VioletHLGroup' })
