vim.opt_local.wrap = true
vim.api.nvim_set_hl(0, '@module', { link = '@function.builtin' })
vim.api.nvim_set_hl(0, '@markup.math', { link = 'Special' })
vim.api.nvim_set_hl(0, '@markup', { fg = 'white' })
vim.api.nvim_set_hl(0, '@markup.strong', { fg = 'white', bold = true })
vim.api.nvim_set_hl(0, '@markup.italic', { fg = 'white', italic = true })

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

local bufnr = vim.api.nvim_get_current_buf() ---@type number
---@return table: A list of label entries with their text, line, column, and file path
local function get_labels()
  local parser = vim.treesitter.get_parser(bufnr, 'latex') ---@type vim.treesitter.LanguageTree
  local root = parser:parse()[1]:root() ---@type table<integer, TSTree>
  local query_string = '(label_definition (curly_group_text (text) @label_title))' ---@type string
  local query = vim.treesitter.query.parse('latex', query_string) ---@type table<integer, TSQuery>
  local labels = {}
  for _, match, _ in query:iter_matches(root, bufnr, 0, -1) do
    for _, node in pairs(match) do
      local text = vim.treesitter.get_node_text(node, 0) ---@type string
      local line, col, _, _ = node:range() ---@type integer, integer, integer, integer
      line = line + 1
      col = col + 1
      local entry = {
        text = text,
        line = line,
        col = col,
        path = vim.api.nvim_buf_get_name(0),
      }
      table.insert(labels, entry)
    end
  end
  return labels
end

---@return table: A list of heading entries with their text, line, column, and file path
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
        local line, col, _, _ = node:range() ---@type integer, integer, integer, integer
        line = line + 1
        col = col + 1
        text = string.upper(command:sub(1, 1)) .. command:sub(2) .. ': ' .. text
        local entry = {
          text = text,
          line = line,
          col = col,
          path = vim.api.nvim_buf_get_name(0), ---@type string
        }
        table.insert(headings, entry)
        -- make sure they are sorted by line number
        table.sort(headings, function(a, b)
          return a.line < b.line
        end)
      end
    end
  end
  return headings
end

---@param entry table: A list of entries with their text, line, and column information
---@param title string: The title for the location list
local function gen_loclist(entry, title)
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
  for _, i in ipairs(entry) do
    table.insert(toc, {
      bufnr = bufnr,
      lnum = i.line, ---@type integer
      col = i.col, ---@type integer
      text = i.text,
    })
  end
  -- Set the location list with TOC entries
  vim.fn.setloclist(0, toc)
  -- Set the title for the location list
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
  gen_loclist(get_headings(), 'LaTeX TOC')
end, { silent = true, noremap = true, desc = 'User: show LaTeX TOC' })
vim.api.nvim_create_user_command('GetLatexLabels', function()
  gen_loclist(get_labels(), 'LaTeX Labels')
end, { nargs = 0, desc = 'Generate a location list with LaTeX labels' })

vim.cmd [[packadd matchit]]

-- snippet support
if false then
  vim.keymap.set({ 'i', 's' }, '<A-j>', function()
    if vim.snippet.active { direction = 1 } then
      vim.schedule(function()
        vim.snippet.jump(1)
      end)
      return
    end
  end, { silent = true })
  vim.keymap.set({ 'i', 's' }, '<A-k>', function()
    if vim.snippet.active { direction = -1 } then
      vim.schedule(function()
        vim.snippet.jump(-1)
      end)
      return
    end
  end, { silent = true })

  -- find the snippets file in the config directory
  local snips_path = vim.fn.expand('$MYVIMRC'):match '(.*[/\\])' .. 'snippets/json_snippets/tex.json'
  -- read it as a string
  local snips = require('snippet').read_file(snips_path)
  -- parse it and format it
  local lsp_snip = require('snippet').process_snippets(snips, 'USR')
  -- start the mock LSP server and load it with the snippets
  require('snippet').start_mock_lsp(lsp_snip)
end
