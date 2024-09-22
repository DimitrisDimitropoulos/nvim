vim.opt_local.wrap = true

local function moving_wrap(direction)
  return (vim.v.count == 0) and 'g' .. direction or direction
end
vim.keymap.set({ 'n', 'x' }, 'k', function()
  return moving_wrap 'k'
end, { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'j', function()
  return moving_wrap 'j'
end, { expr = true, silent = true })

vim.keymap.set({ 'i', 'n' }, '<A-b>', function()
  if vim.opt.keymap:get() == 'greek_utf-8' then
    vim.opt.keymap = ''
  else
    vim.opt.keymap = 'greek_utf-8'
  end
end, { silent = false, noremap = true, desc = 'toggle greek keymap' })

-- BUG: For some reason this does not work, @2024-01-25 01:51:09
vim.cmd.syntax 'spell toplevel'

local util = require 'lspconfig.util'
local function buf_find_envs(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local texlab_client = util.get_active_client_by_name(bufnr, 'texlab')
  if not texlab_client then
    return vim.notify('Texlab client not found', vim.log.levels.ERROR)
  end
  local pos = vim.api.nvim_win_get_cursor(0)
  texlab_client.request('workspace/executeCommand', {
    command = 'texlab.findEnvironments',
    arguments = {
      {
        textDocument = { uri = vim.uri_from_bufnr(bufnr) },
        position = { line = pos[1] - 1, character = pos[2] },
      },
    },
  }, function(err, result)
    if err then
      return vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
    end
    local env_names = {}
    local max_length = 1
    for _, env in ipairs(result) do
      table.insert(env_names, env.name.text)
      max_length = math.max(max_length, string.len(env.name.text))
    end
    for i, name in ipairs(env_names) do
      env_names[i] = string.rep(' ', i - 1) .. name
    end
    vim.lsp.util.open_floating_preview(env_names, '', {
      height = #env_names,
      width = math.max((max_length + #env_names - 1), (string.len 'Environments')),
      focusable = false,
      focus = false,
      border = vim.g.border_style,
      title = 'Environments',
    })
  end, bufnr)
end
vim.api.nvim_create_user_command('TexlabPrettyEnvs', function()
  buf_find_envs(0)
end, { nargs = 0, desc = 'Find environments at cursor and display as popup' })

local bufnr = vim.api.nvim_get_current_buf() ---@type number
local ansi_codes = require('fzf-lua.utils').ansi_codes
local make_entry = require 'fzf-lua.make_entry'
local config = require 'fzf-lua.config'
local function get_labels()
  local parser = vim.treesitter.get_parser(bufnr, 'latex')
  local root = parser:parse()[1]:root()
  local query_string = '(label_definition (curly_group_text (text) @label_title))'
  local query = vim.treesitter.query.parse('latex', query_string)
  local labels = {}
  for _, match, _ in query:iter_matches(root, bufnr, 0, -1) do
    for _, node in pairs(match) do
      local text = vim.treesitter.get_node_text(node, 0)
      local line, start, _, _ = node:range()
      line = line + 1
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

---@brief
-- Extracts all LaTeX section headings from the current buffer.
--
-- This function uses Tree-sitter to parse the current buffer and identify
-- various LaTeX sectioning commands such as `part`, `chapter`, `section`,
-- `subsection`, etc. It constructs and executes queries for each sectioning
-- command to locate the headings in the document.
--
---@return table: A list of heading entries, where each entry is a table with the following keys:
--   - `type` (string): The type of sectioning command (e.g., 'section').
--   - `text` (string): The text of the heading.
--   - `line` (integer): The 1-based line number of the heading.
--   - `start` (integer): The starting column of the heading text.
--   - `path` (string): The path of the current buffer.
local function get_headings()
  local parser = vim.treesitter.get_parser(bufnr, 'latex') ---@type vim.treesitter.LanguageTree
  local root = parser:parse()[1]:root() ---@type table<integer, TSTree>
  -- List of LaTeX sectioning commands
  local headings = {}
  for _, command in ipairs {
    'part',
    'chapter',
    'section',
    'subsection',
    'subsubsection',
    'paragraph',
    'subparagraph',
  } do
    -- Construct a query for each LaTeX sectioning command
    local query_string = string.format('(%s (curly_group (text) @heading_title))', command)
    local query = vim.treesitter.query.parse('latex', query_string)
    for _, match, _ in query:iter_matches(root, bufnr, 0, -1) do
      for _, node in pairs(match) do
        local text = vim.treesitter.get_node_text(node, bufnr) ---@type string
        local line, start, _, _ = node:range() ---@type integer, integer, integer, integer
        line = line + 1
        local entry = {
          type = command,
          text = text,
          line = line,
          start = start,
          path = vim.api.nvim_buf_get_name(0), ---@type string
        }
        table.insert(headings, entry)
      end
    end
  end
  return headings
end

---@brief
-- Generates and displays a table of contents (TOC) for the current LaTeX buffer.
--
-- This function checks if a location list window is already open for the
-- current buffer. If so, it reopens the location list. Otherwise, it creates a
-- new location list populated with headings extracted from the LaTeX document.
-- It also sets a title for the location list.
--
---@return nil
--
-- This function does not return any value. It updates the location list window
-- with TOC entries and ensures that the list is associated with the current
-- buffer.
--
---@see get_headings: This function is used to fetch the headings from the current LaTeX document.
local function show_toc()
  local bufname = vim.fn.bufname '%' ---@type string
  -- Get location list info
  local info = vim.fn.getloclist(0, { winid = 1 })
  -- Check if loclist is already open and corresponds to the current buffer
  if info.winid ~= 0 and vim.api.nvim_win_get_var(info.winid, 'qf_toc') == bufname then
    vim.cmd 'lopen'
    return
  end
  -- Generate TOC from headings
  local toc = {}
  for _, heading in ipairs(get_headings()) do
    table.insert(toc, {
      bufnr = bufnr,
      lnum = heading.line, ---@type integer
      col = heading.start + 1, ---@type integer
      -- Capitalize the first letter of the heading type
      text = string.format('%s: %s', string.upper(heading.type:sub(1, 1)) .. heading.type:sub(2), heading.text),
    })
  end
  -- Set the location list with TOC entries
  vim.fn.setloclist(0, toc)
  -- Set the title for the location list
  local title = 'LaTeX TOC'
  if vim.g.document_title then
    title = title .. ' - "' .. vim.g.document_title .. '"'
  end

  -- Update the location list with the title
  vim.fn.setloclist(0, {}, 'r', { title = title })
  vim.cmd 'lopen'
  -- Set a variable in the location list window to identify it as the TOC for this buffer
  local winid = vim.fn.getloclist(0, { winid = 1 }).winid
  if winid ~= 0 then
    vim.api.nvim_win_set_var(winid, 'qf_toc', bufname)
  end
end
vim.keymap.set('n', 'gO', function()
  show_toc()
end, { silent = true, noremap = true, desc = 'User: show LaTeX TOC' })
