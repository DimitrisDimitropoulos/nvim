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

vim.api.nvim_create_autocmd('InsertEnter', {
  group = vim.api.nvim_create_augroup('Colorcolumn', { clear = true }),
  callback = function()
    vim.opt_local.colorcolumn = '80'
  end,
  desc = 'set colorcolumn to 80 on InsertEnter',
})
vim.api.nvim_create_autocmd('InsertLeave', {
  group = vim.api.nvim_create_augroup('Colorcolumn', { clear = true }),
  callback = function()
    vim.opt_local.colorcolumn = ''
  end,
  desc = 'unset colorcolumn on InsertLeave',
})

if vim.version().minor >= 11 then
  vim.opt_local.foldexpr = 'v:lua.vim.lsp.foldexpr()'
end

---@return table: A list of heading entries with their text, line, column, and file path
local function get_headings()
  local bufnr = vim.api.nvim_get_current_buf() ---@type number
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

---@return table: A list of heading entries with their text, line, column, and file path
local function get_headings_11()
  local bufnr = vim.api.nvim_get_current_buf() ---@type number
  local parser = vim.treesitter.get_parser(bufnr, 'latex') ---@type vim.treesitter.LanguageTree
  local tree = parser:parse()[1]
  local root = tree:root() ---@type table<integer, TSTree>
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
      -- Since match now returns a list of nodes, iterate over the list
      for _, nodes in pairs(match) do
        -- Iterate over all the nodes for each capture ID
        for _, node in ipairs(nodes) do
          -- Process each node as before
          if node then
            local text = vim.treesitter.get_node_text(node, bufnr) ---@type string
            if text then
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
            end
          end
        end
      end
    end
  end
  -- Ensure headings are sorted by line number
  table.sort(headings, function(a, b)
    return a.line < b.line
  end)
  return headings
end

vim.keymap.set('n', 'gO', function()
  local gen_loclist = require('utils').gen_loclist
  if vim.version().minor < 11 then
    gen_loclist(get_headings(), 'LaTeX TOC')
  else
    gen_loclist(get_headings_11(), 'LaTeX TOC')
  end
end, { silent = true, noremap = true, desc = 'User: show LaTeX TOC' })
vim.api.nvim_create_user_command('GetLabels', function()
  require('utils').gen_loclist(
    require('utils').get_entries('(label_definition (curly_group_text (text) @label_title))', 'latex'),
    'LaTeX Labels'
  )
end, { nargs = 0, desc = 'Get the LaTeX labels' })

vim.cmd [[packadd matchit]]

if vim.version().minor >= 11 then
  local function buf_change_env()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = vim.lsp.get_clients({ filter = { name = 'texlab', buffer = bufnr } })[1]
    if not client then
      return vim.notify('Texlab client not found', vim.log.levels.ERROR)
    end
    local new_env = vim.fn.input 'Enter the new environment name: '
    if not new_env or new_env == '' then
      return vim.notify('No environment name provided', vim.log.levels.WARN)
    end
    local pos = vim.api.nvim_win_get_cursor(0)
    client:exec_cmd({
      title = 'Change Environment',
      command = 'texlab.changeEnvironment',
      arguments = {
        {
          textDocument = { uri = vim.uri_from_bufnr(bufnr) },
          position = { line = pos[1] - 1, character = pos[2] },
          newName = tostring(new_env),
        },
      },
    }, { bufnr = bufnr })
  end
  vim.api.nvim_create_user_command('TXChangeEnvironment', function()
    buf_change_env()
  end, { nargs = 0, desc = 'Change the current environment' })

  local function buf_find_envs()
    local bufnr = vim.api.nvim_get_current_buf()
    local texlab_client = vim.lsp.get_clients({ filter = { name = 'texlab', buffer = bufnr } })[1]
    if not texlab_client then
      return vim.notify('Texlab client not found', vim.log.levels.ERROR)
    end
    local command = {
      command = 'texlab.findEnvironments',
      arguments = { vim.lsp.util.make_position_params(vim.api.nvim_get_current_win(), texlab_client.offset_encoding) },
    }
    texlab_client:exec_cmd(command, { bufnr = bufnr }, function(err, result)
      if err then
        return vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
      end
      if not result or vim.tbl_isempty(result) then
        return vim.notify('No environments found', vim.log.levels.INFO)
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
        border = require('lspconfig.ui.windows').default_options.border or 'single',
        title = 'Environments',
      })
    end)
  end
  vim.api.nvim_create_user_command('TXFindEnvironments', function()
    buf_find_envs()
  end, { nargs = 0, desc = 'Find LaTeX environments' })

  local function dependency_graph()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = vim.lsp.get_clients({ filter = { name = 'texlab', buffer = bufnr } })[1]
    if not client then
      return vim.notify('Texlab client not found', vim.log.levels.ERROR)
    end
    client:exec_cmd({
      title = 'Dependency Graph',
      command = 'texlab.showDependencyGraph',
      arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
    }, { bufnr = bufnr }, function(err, result)
      if err then
        return vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
      end
      vim.notify('The dependency graph has been generated:\n' .. result, vim.log.levels.INFO)
    end)
  end
  vim.api.nvim_create_user_command('TXShowDependencyGraph', function()
    dependency_graph()
  end, { nargs = 0, desc = 'Show LaTeX dependency graph' })
end
