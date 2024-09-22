vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('AutoFormat', { clear = true }),
  pattern = { '*tex', '*lua', '*py', '*jl', '*json', '*yml', '*rs', '*sh' },
  callback = function()
    vim.lsp.buf.format()
  end,
  desc = 'format on save',
})
