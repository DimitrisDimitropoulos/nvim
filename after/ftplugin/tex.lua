vim.wo[0][0].wrap = true
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
  if vim.o.keymap == 'greek_utf-8' then
    vim.o.keymap = ''
  else
    vim.o.keymap = 'greek_utf-8'
  end
end, { silent = false, noremap = true, desc = 'toggle greek keymap' })

local colorcolumn_group = vim.api.nvim_create_augroup('Colorcolumn', { clear = true })
vim.api.nvim_create_autocmd('InsertEnter', {
  group = colorcolumn_group,
  pattern = { 'tex' },
  callback = function()
    vim.wo[0][0].colorcolumn = '80'
  end,
  desc = 'set colorcolumn to 80 on InsertEnter',
})
vim.api.nvim_create_autocmd('InsertLeave', {
  group = colorcolumn_group,
  pattern = { 'tex' },
  callback = function()
    vim.wo[0][0].colorcolumn = ''
  end,
  desc = 'unset colorcolumn on InsertLeave',
})

---@return table headings the list of headings
local function get_headings()
  local commands = {
    'part',
    'chapter',
    'section',
    'subsection',
    'subsubsection',
    'paragraph',
    'subparagraph',
  }
  local headings = {}
  local tasks = {}
  for _, command in ipairs(commands) do
    table.insert(
      tasks,
      coroutine.create(function()
        local query_string = string.format('(%s (curly_group (text) @heading_title))', command)
        local entries = require('utils').get_entries(query_string, 'latex')
        for _, entry in ipairs(entries) do
          entry.text = string.upper(command:sub(1, 1)) .. command:sub(2) .. ': ' .. entry.text
          table.insert(headings, entry)
        end
      end)
    )
  end
  -- Resume each coroutine until all are finished
  local running = true
  while running do
    running = false
    for _, co in ipairs(tasks) do
      if coroutine.status(co) ~= 'dead' then
        running = true
        local ok, err = coroutine.resume(co)
        if not ok then
          error(err)
        end
      end
    end
  end
  table.sort(headings, function(a, b)
    return a.line < b.line
  end)
  return headings
end

vim.keymap.set('n', 'gO', function()
  require('utils').gen_loclist(get_headings(), 'LaTeX TOC')
end, { silent = true, noremap = true, desc = 'User: show LaTeX TOC' })
vim.api.nvim_create_user_command('GetLabels', function()
  require('utils').gen_loclist(
    require('utils').get_entries('(label_definition name: (curly_group_label label: (label) @label_title))', 'latex'),
    'LaTeX Labels'
  )
end, { nargs = 0, desc = 'Get the LaTeX labels' })

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
vim.api.nvim_create_user_command('TexlabShowDependencyGraph', function()
  dependency_graph()
end, { nargs = 0, desc = 'Show LaTeX dependency graph' })
