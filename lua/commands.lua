vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('HighlightOnYank', { clear = true }),
  callback = function()
    vim.hl.on_yank { timeout = 230, higroup = 'Visual' }
  end,
  desc = 'highlight on yank',
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('GotoLastLoc', { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = 'last loc',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('SpellOn', { clear = true }),
  pattern = { 'gitcommit', 'markdown', 'tex', 'context', 'typst' },
  callback = function()
    vim.opt_local.spell = true
  end,
  desc = 'spell on specific filetypes',
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('MakeExecutable', { clear = true }),
  pattern = { '*.sh', '*.bash', '*.zsh' },
  callback = function()
    vim.fn.system('chmod +x ' .. vim.fn.expand '%')
  end,
  desc = 'make executable',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('UserTreesitter', { clear = true }),
  desc = 'handle the loading and usage of treesitter',
  callback = function(args)
    local bufnr = args.buf
    if pcall(vim.treesitter.start, bufnr, vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)) then
      vim.treesitter.start(bufnr, vim.treesitter.language.get_lang(vim.bo[bufnr].filetype))
      vim.wo[0][0].foldmethod = 'expr'
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    else
      vim.cmd [[ syntax on ]]
      vim.wo[0][0].foldmethod = 'manual'
    end
  end,
})

local paths = {
  vim.fn.stdpath 'data' .. '/lazy/friendly-snippets/package.json',
  vim.fn.expand('$MYVIMRC'):match '(.*[/\\])' .. 'snippets/json_snippets/package.json',
}
local descs = { 'FR', 'USR' }
local sn_group = vim.api.nvim_create_augroup('SnippetServer', { clear = true })
vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  group = sn_group,
  once = true,
  callback = function()
    require('snippet').snippet_handler(paths, vim.bo.filetype, descs)
    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
      group = sn_group,
      callback = function()
        require('snippet').snippet_handler(paths, vim.bo.filetype, descs)
      end,
      desc = 'Handle LSP for buffer changes',
    })
  end,
})
