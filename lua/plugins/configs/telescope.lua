local telescope_ok, telescope = pcall(require, 'telescope')
if not telescope_ok then return end

local extras = {
  fzf = { case_mode = 'smart_case' },
}

local previewers = require 'telescope.previewers'

telescope.setup {
  defaults = {
    prompt_prefix = '   ',
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    file_ignore_patterns = { '.git', 'build', 'LICENSE' },
    sorting_strategy = 'ascending',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = { mirror = false },
      width = 0.97,
      height = 0.95,
      preview_cutoff = 120,
    },
    preview = {
      treesitter = false,
      filesize_limit = 1,
      timeout = 250,
      -- truncate for preview
      filesize_hook = function(filepath, bufnr, opts)
        local path = require('plenary.path'):new(filepath)
        -- opts exposes winid
        local height = vim.api.nvim_win_get_height(opts.winid)
        local lines = vim.split(path:head(height), '[\r]?\n')
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      end,
    },
    vimgrep_arguments = {
      'rg',
      '-L',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
  },
  pickers = { diagnostics = { path_display = 'hidden' } },
  set_env = { ['COLORTERM'] = 'truecolor' },
  extensions = extras,
}

local tel_plugs = { 'fzf' }
for _, plug in ipairs(tel_plugs) do
  require('telescope').load_extension(plug)
end

-- =============================================================================
--  Mapps for Telescope and it's extensions --
-- =============================================================================
local map = vim.keymap.set

local telescope_mappings = {
  -- stylua: ignore start
  { key = 'ff', cmd = 'fd',                        desc = 'files' },
  { key = 'fr', cmd = 'oldfiles',                  desc = 'old files' },
  { key = 'f;', cmd = 'commands',                  desc = 'commands' },
  { key = 'fg', cmd = 'live_grep',                 desc = 'live grep' },
  { key = 'fs', cmd = 'grep_string',               desc = 'cursor string' },
  { key = 'bb', cmd = 'buffers',                   desc = 'buffers' },
  { key = 'fh', cmd = 'help_tags',                 desc = 'help tags' },
  { key = 'f/', cmd = 'search_history',            desc = 'history' },
  { key = 'fm', cmd = 'marks',                     desc = 'marks' },
  { key = 'fk', cmd = 'keymaps',                   desc = 'keymaps' },
  { key = 'fe', cmd = 'registers',                 desc = 'registers' },
  { key = 'fd', cmd = 'diagnostics',               desc = 'diagnostics' },
  { key = 'fc', cmd = 'command_history',           desc = 'command history' },
  { key = 'fl', cmd = 'lsp_document_symbols',      desc = 'lsp document symbols' },
  { key = 'sp', cmd = 'spell_suggest',             desc = 'spell suggest' },
  { key = 'fz', cmd = 'current_buffer_fuzzy_find', desc = 'buf fuzzy' },
  { key = 'f.', cmd = 'resume',                    desc = 'last' },
  -- stylua: ignore stop
}
for _, mapping in ipairs(telescope_mappings) do
  map(
    'n',
    '<leader>' .. mapping.key,
    function() require('telescope.builtin')[mapping.cmd]() end,
    { desc = 'find ' .. mapping.desc }
  )
end

map(
  'n',
  '<leader>fa',
  function()
    require('telescope.builtin').fd { hidden = true, follow = true, no_ignore = true, file_ignore_patterns = { '.git' } }
  end,
  { desc = 'find all files' }
)
