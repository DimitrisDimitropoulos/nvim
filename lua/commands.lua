local map = vim.keymap.set
local function augroup(name) return vim.api.nvim_create_augroup(name, { clear = true }) end

vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup 'YankHighlight',
  callback = function() vim.highlight.on_yank { timeout = 230, higroup = 'Visual' } end,
  desc = 'highlight on yank',
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup 'last_loc',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
  desc = 'last loc',
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'close_with_q',
  pattern = { 'help', 'lspinfo', 'man', 'qf', 'query', 'checkhealth' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    map('n', 'q', function() vim.cmd 'close' end, { buffer = event.buf, silent = true })
  end,
  desc = 'close with q',
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'spell',
  pattern = { 'gitcommit', 'markdown' },
  callback = function() vim.opt_local.spell = true end,
  desc = 'spell on specific filetypes',
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup 'MakeExecutable',
  pattern = { '*.sh', '*.bash', '*.zsh' },
  callback = function() vim.fn.system('chmod +x ' .. vim.fn.expand '%') end,
  desc = 'make executable',
})

local function toggle_spell_check() vim.opt.spell = not (vim.opt.spell:get()) end
map('n', '<A-z>', toggle_spell_check, { desc = 'toggle spell check', silent = false, noremap = true })
