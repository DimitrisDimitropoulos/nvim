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
    border = vim.g.border_style,
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
  { key = 'ft', cmd = 'git_status' },
} do
  vim.keymap.set('n', '<leader>' .. mapping.key, function()
    require('fzf-lua')[mapping.cmd]()
  end, { desc = 'fzf-lua ' .. mapping.cmd:gsub('_', ' ') })
end

vim.keymap.set('n', '<leader>fa', function()
  require('fzf-lua').files { cmd = 'rg --files --hidden -u --glob !.git' }
end, { desc = 'fzf-lua all files' })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('Labels', { clear = true }),
  pattern = { 'tex' },
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf() ---@type number
    local ansi_codes = require('fzf-lua.utils').ansi_codes
    local make_entry = require 'fzf-lua.make_entry'
    local config = require 'fzf-lua.config'
    ---@brief Extracts all LaTeX labels from the current buffer.
    ---
    --- This function uses Tree-sitter to parse the current buffer and identify
    --- LaTeX label definitions. It constructs and executes a query to locate
    --- the labels in the document.
    ---
    ---@return table: A list of label entries, where each entry is a table with the following keys:
    ---   - `text` (string): The text of the label.
    ---   - `line` (integer): The 1-based line number of the label.
    ---   - `start` (integer): The starting column of the label text.
    ---   - `path` (string): The path of the current buffer.
    local function get_labels()
      local parser = vim.treesitter.get_parser(bufnr, 'latex') ---@type vim.treesitter.LanguageTree
      local root = parser:parse()[1]:root() ---@type table<integer, TSTree>
      local query_string = '(label_definition (curly_group_text (text) @label_title))' ---@type string
      local query = vim.treesitter.query.parse('latex', query_string) ---@type table<integer, TSQuery>
      local labels = {}
      for _, match, _ in query:iter_matches(root, bufnr, 0, -1) do
        for _, node in pairs(match) do
          local text = vim.treesitter.get_node_text(node, 0) ---@type string
          local line, start, _, _ = node:range() ---@type integer, integer, integer, integer
          line = line + 1
          start = start + 1
          local entry = {
            text = text,
            line = line,
            start = start,
            path = vim.api.nvim_buf_get_name(0),
          }
          table.insert(labels, entry)
        end
      end
      return labels
    end
    vim.api.nvim_create_user_command('GetLabels', function()
      get_labels()
    end, { nargs = 0 })

    ---@brief Prepares LaTeX labels for display in fzf.
    ---
    --- This function formats each label entry into a string suitable for fzf display.
    --- The format includes the file path, line number, start column, and the label text
    --- highlighted in magenta.
    ---
    ---@param labels table: A list of label entries, where each entry is a table with the following keys:
    ---   - `text` (string): The text of the label.
    ---   - `line` (integer): The 1-based line number of the label.
    ---   - `start` (integer): The starting column of the label text.
    ---   - `path` (string): The path of the current buffer.
    ---@return table: A list of formatted label entries as strings.
    local function prepare_labels(labels)
      local res = {}
      for _, label in ipairs(labels) do
        local entry = ('%s:%s:%s:%s'):format(
          make_entry.file(label.path),
          tostring(label.line),
          tostring(label.start),
          ansi_codes.magenta(label.text)
        )
        table.insert(res, entry)
      end
      return res
    end

    ---@brief Displays LaTeX labels using fzf.
    ---
    --- This function retrieves LaTeX labels from the current buffer, prepares them
    --- for display, and then invokes fzf with the prepared entries. The fzf prompt
    --- is customized, and options are normalized and configured for the fzf
    --- execution.
    local function fzf_label()
      local labels = get_labels()
      local entries = prepare_labels(labels)
      local _config = { prompt = 'Labels>' }
      _config = config.normalize_opts(_config, config.globals.grep)
      _config.fzf_opts = {
        ['--with-nth'] = '4..',
        ['--delimiter'] = ':',
      }
      _config.previewer = 'builtin'
      require('fzf-lua').fzf_exec(entries, _config)
    end
    vim.api.nvim_create_user_command('Fzflatexlabels', function()
      fzf_label()
    end, { nargs = 0, desc = 'FzfLua get LaTeX labels based on treesitter' })
  end,
})
