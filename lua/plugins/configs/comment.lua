local Comment_ok, Comment = pcall(require, 'Comment')
if not Comment_ok then
  return
end

Comment.setup {
  vim.keymap.set('n', '<leader>/', function()
    require('Comment.api').toggle.linewise.current()
  end, { desc = 'comment line', noremap = true, silent = false }),
  vim.keymap.set('v', '<leader>/', function()
    local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'x', false)
    require('Comment.api').toggle.linewise(vim.fn.visualmode())
  end, { desc = 'comment in visual mode' }),
}
