vim.opt_local.wrap = true
vim.api.nvim_set_hl(0, '@module', { link = '@function.builtin' })
vim.api.nvim_set_hl(0, '@markup.math', { link = 'Special' })
vim.api.nvim_set_hl(0, '@markup', { fg = 'white' })
vim.api.nvim_set_hl(0, '@markup.strong', { fg = 'white', bold = true })
vim.api.nvim_set_hl(0, '@markup.italic', { fg = 'white', italic = true })

for _, dir in ipairs { 'j', 'k' } do
  vim.keymap.set({ 'n', 'x' }, dir, function()
    return (vim.v.count == 0) and 'g' .. dir or dir
  end, { silent = true, noremap = true, expr = true })
end

vim.keymap.set({ 'i', 'n' }, '<A-b>', function()
  if vim.opt.keymap:get() == 'greek_utf-8' then
    vim.opt.keymap = ''
  else
    vim.opt.keymap = 'greek_utf-8'
  end
end, { silent = false, noremap = true, desc = 'toggle greek keymap' })

local colorcolumn_group = vim.api.nvim_create_augroup('Colorcolumn', { clear = true })
vim.api.nvim_create_autocmd('InsertEnter', {
  group = colorcolumn_group,
  callback = function()
    vim.opt_local.colorcolumn = '80'
  end,
  desc = 'set colorcolumn to 80 on InsertEnter',
})
vim.api.nvim_create_autocmd('InsertLeave', {
  group = colorcolumn_group,
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

if vim.version().minor >= 11 then
  local function buf_change_env()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = vim.lsp.get_clients({ name = 'texlab', buffer = bufnr })[1]
    if not client then
      return vim.notify('Texlab client not found', vim.log.levels.ERROR)
    end
    local new_env
    vim.ui.input({ prompt = 'New environment name: ' }, function(input)
      new_env = input
    end)
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
    local texlab_client = vim.lsp.get_clients({ name = 'texlab', buffer = bufnr })[1]
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

  -- Enhanced function to parse DOT graph into a Lua table
  local function parse_dot(dot_str)
    local graph = { nodes = {}, edges = {} }
    -- Parse nodes
    for id, label in dot_str:gmatch '(%w+)%s*%[label="(.-)", shape=%w+%]' do
      graph.nodes[id] = label:match '.*/(.-)$' or label -- Extract filename from full path
    end
    -- Parse edges
    for from, to, edge_label in dot_str:gmatch '(%w+)%s*%->%s*(%w+)%s*%[label="(.-)"%]' do
      table.insert(graph.edges, {
        from = from,
        to = to,
        label = edge_label,
      })
    end
    return graph
  end
  -- Function to render the graph with node labels instead of IDs
  local function render_graph(graph)
    local output = {}
    table.insert(output, 'ASCII Representation of DOT Graph:')
    table.insert(output, 'Press P to show the original DOT graph')
    for _, edge in ipairs(graph.edges) do
      local from_label = graph.nodes[edge.from] or edge.from
      local to_label = graph.nodes[edge.to] or edge.to
      table.insert(output, string.format('%s -> %s', from_label, edge.label))
    end
    return table.concat(output, '\n')
  end
  -- Handler function for the LSP command
  -- Updated dependency_graph function with split buffer
  local function dependency_graph()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = vim.lsp.get_clients({ name = 'texlab', buffer = bufnr })[1]
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
      -- Parse and render the graph
      local graph = parse_dot(result)
      local rendered_graph = render_graph(graph)
      -- Open a new split buffer for the graph
      vim.cmd 'split DependencyGraph'
      local new_bufnr = vim.api.nvim_get_current_buf()
      -- Set the rendered graph content in the new buffer
      local lines = vim.split(rendered_graph, '\n')
      vim.api.nvim_buf_set_lines(new_bufnr, 0, -1, true, lines)
      -- Set buffer options
      vim.bo[new_bufnr].modifiable = false
      vim.bo[new_bufnr].filetype = 'DependencyGraph'
      vim.bo[new_bufnr].buftype = 'nofile'
      vim.bo[new_bufnr].bufhidden = 'wipe'
      vim.bo[new_bufnr].buflisted = true
      -- Adjust split height and add keymap to quit the split
      vim.api.nvim_win_set_height(0, math.min(#lines, 15))
      vim.keymap.set('n', 'q', '<cmd>q<CR>', { noremap = true, silent = true, buffer = new_bufnr })
      vim.keymap.set('n', 'P', function()
        vim.notify(result, vim.log.levels.INFO)
      end, { noremap = true, silent = true, buffer = new_bufnr })
    end)
  end

  -- Create the user command
  vim.api.nvim_create_user_command('TXShowDependencyGraph', function()
    dependency_graph()
  end, { nargs = 0, desc = 'Show LaTeX dependency graph' })

  --
end
