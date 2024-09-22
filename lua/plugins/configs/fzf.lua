local fzf_lua_ok, fzf_lua = pcall(require, 'fzf-lua')
if not fzf_lua_ok then
  return
end

fzf_lua.setup {
  fzf_opts = { ['--no-scrollbar'] = true, ['--cycle'] = true, ['--info'] = 'inline' },
  grep = {
    prompt = 'rg>',
    rg_opts = '--hidden --no-heading --color=always --max-columns=4096 --smart-case --line-number --column --with-filename --glob !.git --glob !build --glob !spell --glob !lockfiles --glob !LICENSE',
  },
  files = {
    cmd = 'rg --files --smart-case --color=never --follow --glob !.git --glob !build --glob !spell --glob !lockfiles',
    cwd_prompt = true,
    cwd_prompt_shorten_len = 1,
  },
  oldfiles = {
    include_current_session = true,
  },
  keymap = {
    builtin = {
      ['<A-a>'] = 'toggle-fullscreen',
      ['<A-d>'] = 'preview-page-down',
      ['<A-u>'] = 'preview-page-up',
      ['<A-w>'] = 'toggle-preview-cw',
      ['<A-h>'] = 'toggle-preview',
      ['<A-k>'] = 'first',
      ['<A-j>'] = 'last',
    },
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
      ['alt-h'] = 'toggle-preview',
      ['alt-u'] = 'preview-page-up',
      ['alt-d'] = 'preview-page-down',
      ['alt-k'] = 'first',
      ['alt-j'] = 'last',
    },
  },
  winopts = {
    height = 0.97,
    width = 0.95,
    preview = {
      default = 'bat',
      horizontal = 'right:50%',
      delay = 50,
      scrollbar = false,
      winopts = { number = false },
    },
  },
  previewers = {
    bat = {
      cmd = 'bat',
      args = '--color=always --style=changes --line-range :512',
      theme = 'gruvbox-dark',
    },
  },
}

for _, mapping in ipairs {
  { key = 'ff', cmd = 'files' },
  { key = 'fr', cmd = 'oldfiles' },
  { key = 'f;', cmd = 'commands' },
  { key = 'fg', cmd = 'live_grep' },
  { key = 'fb', cmd = 'buffers' },
  { key = 'fh', cmd = 'helptags' },
  { key = 'f/', cmd = 'search_history' },
  { key = 'fm', cmd = 'marks' },
  { key = 'fk', cmd = 'keymaps' },
  { key = 'fe', cmd = 'registers' },
  { key = 'fd', cmd = 'diagnostics_document' },
  { key = 'fD', cmd = 'diagnostics_workspace' },
  { key = 'fc', cmd = 'command_history' },
  { key = 'fl', cmd = 'lsp_document_symbols' },
  { key = 'fw', cmd = 'lsp_workspace_symbols' },
  { key = 'sp', cmd = 'spell_suggest' },
  { key = 'f.', cmd = 'resume' },
  { key = 'fg', cmd = 'live_grep' },
  { key = 'fs', cmd = 'grep_cword' },
  { key = 'fS', cmd = 'grep_cWORD' },
} do
  vim.keymap.set('n', '<leader>' .. mapping.key, function()
    require('fzf-lua')[mapping.cmd]()
  end, { desc = 'fzf-lua ' .. mapping.cmd:gsub('_', ' ') })
end

vim.keymap.set('n', '<leader>fa', function()
  require('fzf-lua').files { cmd = 'rg --files --hidden -u --glob !.git' }
end, { desc = 'fzf-lua all files' })

local document_symbols = function()
  local symbols = {
    'All',
    'Variable',
    'Function',
    'Module',
    'Constant',
    'Class',
    'Property',
    'Method',
    'Enum',
    'Interface',
    'Boolean',
    'Number',
    'String',
    'Array',
    'Constructor',
  }
  vim.ui.select(symbols, { prompt = 'Select which symbol' }, function(item)
    if item == 'All' then
      require('fzf-lua').lsp_workspace_symbols()
    else
      require('fzf-lua').lsp_workspace_symbols { query = item }
    end
  end)
end
vim.keymap.set('n', '<leader>fW', document_symbols, { desc = 'fzf-lua select lsp workspace symbols' })
