local fzf_lua_ok, fzf_lua = pcall(require, 'fzf-lua')
if not fzf_lua_ok then
  return
end

fzf_lua.setup {
  fzf_opts = {
    ['--no-scrollbar'] = true,
    ['--cycle'] = true,
    ['--info'] = 'inline',
    ['--separator'] = ' ',
    ['--pointer'] = '>',
    ['--preview-window'] = 'right,50%,border-left,<50(down,40%,border-top)',
  },
  fzf_colors = { ['gutter'] = { 'bg', 'Normal' } },
  diagnostics = { fzf_opts = { ['--pointer'] = '│' } },
  grep = {
    prompt = 'rg>',
    rg_opts = '--hidden --no-heading --color=always --max-columns=4096 --smart-case --line-number --column --with-filename --glob !.git --glob !build --glob !spell --glob !lockfiles --glob !LICENSE',
  },
  files = {
    formatter = 'path.dirname_first',
    cmd = 'rg --files --smart-case --color=never --follow --glob !.git --glob !build --glob !spell',
    hidden = false,
    cwd_prompt = true,
    cwd_prompt_shorten_len = 1,
    git_icons = true,
  },
  oldfiles = {
    include_current_session = true,
  },
  zoxide = {
    preview = 'eza -laho --no-filesize --no-user --color-scale --no-git --time-style iso --color=always  {2}',
  },
  keymap = {
    builtin = {
      ['<A-a>'] = 'toggle-fullscreen',
      ['<A-d>'] = 'preview-page-down',
      ['<A-u>'] = 'preview-page-up',
      ['<A-w>'] = 'toggle-preview-cw',
      ['<A-o>'] = 'toggle-preview',
      ['<A-k>'] = 'first',
      ['<A-j>'] = 'last',
    },
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
      ['alt-o'] = 'toggle-preview',
      ['alt-u'] = 'preview-page-up',
      ['alt-d'] = 'preview-page-down',
      ['alt-k'] = 'first',
      ['alt-j'] = 'last',
    },
  },
  winopts = {
    height = 0.97,
    width = 0.95,
    border = vim.o.winborder,
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
  { key = 'fs', cmd = 'grep_cword' },
  { key = 'fS', cmd = 'grep_cWORD' },
  { key = 'ft', cmd = 'git_status' },
  { key = 'fv', cmd = 'loclist' },
  { key = 'fz', cmd = 'zoxide' },
} do
  vim.keymap.set('n', '<leader>' .. mapping.key, function()
    require('fzf-lua')[mapping.cmd]()
  end, { desc = 'fzf-lua ' .. mapping.cmd:gsub('_', ' ') })
end

vim.keymap.set('n', '<leader>fa', function()
  require('fzf-lua').files { cmd = 'rg --files --hidden -u --glob !.git' }
end, { desc = 'fzf-lua all files' })

vim.keymap.set('n', '<leader>fp', function()
  require('fzf-lua').grep { search = [[TODO:|todo!\(.*\)]], no_esc = true }
end, { desc = 'fzf-lua grep TODOs' })
