local telescope_ok, telescope = pcall(require, 'telescope')
if not telescope_ok then
  return
end

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<A-h>'] = require('telescope.actions.layout').toggle_preview,
      },
    },
    prompt_prefix = '>',
    path_display = { 'truncate' },
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
      timeout = 100,
      -- truncate for preview
      filesize_hook = function(filepath, bufnr, opts)
        local path = require('plenary.path'):new(filepath)
        -- opts exposes winid
        local height = vim.api.nvim_win_get_height(opts.winid)
        local lines = vim.split(path:head(height), '[\r]?\n')
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      end,
    },
  },
  pickers = { diagnostics = { path_display = 'hidden' } },
  set_env = { ['COLORTERM'] = 'truecolor' },
}

-- =============================================================================
--  Mapps for Telescope and it's extensions --
-- =============================================================================

for _, mapping in ipairs {
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
  { key = 'ft', cmd = 'git_status' },
  { key = 'fv', cmd = 'loclist' },
} do
  vim.keymap.set('n', '<leader>' .. mapping.key, function()
    require('telescope.builtin')[mapping.cmd]()
  end, { desc = 'telescope ' .. mapping.cmd:gsub('_', ' ') })
end

vim.keymap.set('n', '<leader>fa', function()
  require('telescope.builtin').fd { hidden = true, follow = true, no_ignore = true, file_ignore_patterns = { '.git' } }
end, { desc = 'telescope all files' })
