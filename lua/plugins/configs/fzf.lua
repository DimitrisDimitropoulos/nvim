local fzf_lua_ok, fzf_lua = pcall(require, 'fzf-lua')
if not fzf_lua_ok then
  return
end

fzf_lua.setup {
  fzf_opts = { ['--no-scrollbar'] = true },
  grep = {
    prompt = 'rg> ',
    rg_opts = '--hidden --no-heading --color=never --smart-case --max-columns=4096 --glob !.git --glob !build --glob !spell --glob !lockfiles --glob !LICENSE',
  },
  files = {
    cmd = 'rg --files --glob !.git --glob !build --glob !spell --glob !lockfiles',
    cwd_prompt = true,
    cwd_prompt_shorten_len = 1,
  },
  keymap = {
    builtin = {
      ['<A-a>'] = 'toggle-fullscreen',
      ['<A-d>'] = 'preview-page-down',
      ['<A-u>'] = 'preview-page-up',
      ['<A-w>'] = 'toggle-preview-cw',
    },
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
      ['alt-h'] = 'toggle-preview', -- BUG: works with the bat previewer, @2024-07-11 01:06:43
    },
  },
  defaults = {
    formatter = 'path.filename_first',
    multiline = 1,
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
}

local fzf_maps = {
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
  { key = 'fL', cmd = 'lsp_workspace_symbols' },
  { key = 'sp', cmd = 'spell_suggest' },
  { key = 'f.', cmd = 'resume' },
  { key = 'fg', cmd = 'live_grep' },
  { key = 'fs', cmd = 'grep_cword' },
  { key = 'fS', cmd = 'grep_cWORD' },
}
for _, mapping in ipairs(fzf_maps) do
  vim.keymap.set('n', '<leader>' .. mapping.key, function()
    require('fzf-lua')[mapping.cmd]()
  end, { desc = 'fzf-lua ' .. mapping.cmd:gsub('_', ' ') })
end

vim.keymap.set('n', '<leader>fa', function()
  require('fzf-lua').files { cmd = 'rg --files --hidden -u' }
end, { desc = 'fzf-lua all files' })
