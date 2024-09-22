local telescope_ok, telescope = pcall(require, 'telescope')
if not telescope_ok then return end

telescope.setup {
  defaults = {
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    file_ignore_patterns = { '.git', 'build' },
    sorting_strategy = 'ascending',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = { mirror = false },
      width = 0.97,
      height = 0.90,
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
  mappings = {
    n = { ['q'] = require('telescope.actions').close },
  },
  pickers = {
    diagnostics = {
      path_display = 'hidden',
    },
  },
  path_display = { 'truncate' },
  color_devicons = true,
  set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
  extensions = {
    ['zf-native'] = {
      file = {
        enable = true,
        highlight_results = true,
        match_filename = true,
      },
      generic = {
        enable = true,
        highlight_results = true,
        match_filename = false,
      },
    },
    file_browser = {
      theme = 'ivy',
      layout_config = { height = 0.85 },
    },
  },
}

local tel_plugs = { 'zf-native', 'file_browser' }
for _, plug in ipairs(tel_plugs) do
  require('telescope').load_extension(plug)
end

-- =============================================================================
--  Mapps for Telescope and it's extensions --
-- =============================================================================
local map = vim.keymap.set

local telescope_mappings = {
  -- stylua: ignore start
  { key = "ff", cmd = "fd",                        desc = "files" },
  { key = "fr", cmd = "oldfiles",                  desc = "old files" },
  { key = "f;", cmd = "commands",                  desc = "commands" },
  { key = "fg", cmd = "live_grep",                 desc = "live grep" },
  { key = "fs", cmd = "grep_string",               desc = "cursor string" },
  { key = "bb", cmd = "buffers",                   desc = "buffers" },
  { key = "fh", cmd = "help_tags",                 desc = "help tags" },
  { key = "fm", cmd = "marks",                     desc = "marks" },
  { key = "fk", cmd = "keymaps",                   desc = "keymaps" },
  { key = "fe", cmd = "registers",                 desc = "registers" },
  { key = "fd", cmd = "diagnostics",               desc = "diagnostics" },
  { key = "fc", cmd = "command_history",           desc = "command history" },
  { key = "ld", cmd = "lsp_document_symbols",      desc = "lsp definitions" },
  { key = "sp", cmd = "spell_suggest",             desc = "spell suggest" },
  { key = "fz", cmd = "current_buffer_fuzzy_find", desc = "buf fuzzy" },
  { key = "gs", cmd = "git_status",                desc = "git status" },
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
  '<leader>ts',
  function()
    require('telescope.builtin').treesitter {
      default_text = 'function',
      initial_mode = 'normal',
    }
  end,
  { desc = 'find treesitter' }
)
map(
  'n',
  '<leader>fa',
  function()
    require('telescope.builtin').fd {
      hidden = true,
      follow = true,
      no_ignore = true,
      file_ignore_patterns = { '.git' },
    }
  end,
  { desc = 'find files' }
)

map(
  'n',
  '<leader>fb',
  function() require('telescope').extensions.file_browser.file_browser { initial_mode = 'normal' } end,
  { desc = 'file browser', noremap = true }
)
