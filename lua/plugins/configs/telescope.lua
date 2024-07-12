local telescope_ok, telescope = pcall(require, 'telescope')
if not telescope_ok then
  return
end

local extras = {
  fzf = { case_mode = 'smart_case' },
}

local previewers = require 'telescope.previewers'

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<A-h>'] = require('telescope.actions.layout').toggle_preview,
      },
    },
    prompt_prefix = '>',
    -- prompt_prefix = '   ',
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    path_display = { 'filename_first' },
    file_ignore_patterns = { '.git', 'build', 'LICENSE', 'lockfiles', 'spell', 'png', 'jpg', 'jpeg', 'gif', 'webp' },
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

local telescope_mappings = {
  { key = 'ff', cmd = 'fd' },
  { key = 'fr', cmd = 'oldfiles' },
  { key = 'f;', cmd = 'commands' },
  { key = 'fg', cmd = 'live_grep' },
  { key = 'fs', cmd = 'grep_string' },
  { key = 'fb', cmd = 'buffers' },
  { key = 'fh', cmd = 'help_tags' },
  { key = 'f/', cmd = 'search_history' },
  { key = 'fm', cmd = 'marks' },
  { key = 'fk', cmd = 'keymaps' },
  { key = 'fe', cmd = 'registers' },
  { key = 'fd', cmd = 'diagnostics' },
  { key = 'fc', cmd = 'command_history' },
  { key = 'fl', cmd = 'lsp_document_symbols' },
  { key = 'fw', cmd = 'lsp_workspace_symbols' },
  { key = 'sp', cmd = 'spell_suggest' },
  { key = 'fz', cmd = 'current_buffer_fuzzy_find' },
  { key = 'f.', cmd = 'resume' },
}
for _, mapping in ipairs(telescope_mappings) do
  vim.keymap.set('n', '<leader>' .. mapping.key, function()
    require('telescope.builtin')[mapping.cmd]()
  end, { desc = 'telescope ' .. mapping.cmd:gsub('_', ' ') })
end

vim.keymap.set('n', '<leader>fa', function()
  require('telescope.builtin').fd { hidden = true, follow = true, no_ignore = true, file_ignore_patterns = { '.git' } }
end, { desc = 'telescope all files' })

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
      require('telescope.builtin').lsp_workspace_symbols()
    else
      require('telescope.builtin').lsp_workspace_symbols { symbols = item }
    end
  end)
end
vim.keymap.set('n', '<leader>fW', document_symbols, { desc = 'telescope select lsp document symbols' })
