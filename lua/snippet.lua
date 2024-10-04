local M = {}

---@param path string
---@return string buffer @content of file
function M.read_file(path)
  -- permissions: rrr
  --
  local fd = assert(vim.uv.fs_open(path, 'r', tonumber('0444', 8)))
  local stat = assert(vim.uv.fs_fstat(fd))
  -- read from offset 0.
  local buf = assert(vim.uv.fs_read(fd, stat.size, 0))
  vim.uv.fs_close(fd)
  return buf
end

---@param pkg_path string
---@param lang string
---@return table<string>
function M.parse_pkg(pkg_path, lang)
  local pkg = M.read_file(pkg_path)
  local data = vim.json.decode(pkg)
  local base_path = vim.fn.fnamemodify(pkg_path, ':h')
  local file_paths = {}
  for _, snippet in ipairs(data.contributes.snippets) do
    local languages = snippet.language
    -- Check if it's a list of languages or a single language
    if type(languages) == 'string' then
      languages = { languages }
    end
    -- If a language is provided, check for a match
    if not lang or vim.tbl_contains(languages, lang) then
      -- Prepend the base path to the relative snippet path
      local abs_path = vim.fn.fnamemodify(base_path .. '/' .. snippet.path, ':p')
      table.insert(file_paths, abs_path)
    end
  end
  return file_paths
end

---@brief Process only one JSON encoded string
---@param snips string: JSON encoded string containing snippets
---@param desc string: Description for the snippets (optional)
---@return table: A table containing completion results formatted for LSP
function M.process_snippets(snips, desc)
  local snippets_table = {}
  local completion_results = {
    isIncomplete = false,
    items = {},
  }
  -- Decode the JSON input
  for _, v in pairs(vim.json.decode(snips)) do
    local prefixes = type(v.prefix) == 'table' and v.prefix or { v.prefix }
    -- Handle v.body as a table or string
    local body
    if type(v.body) == 'table' then
      -- Concatenate the table elements into a single string, separated by newlines
      body = table.concat(v.body, '\n')
    else
      -- If it's already a string, use it directly
      body = v.body
    end
    -- Add each prefix-body pair to the table
    for _, prefix in ipairs(prefixes) do
      snippets_table[prefix] = body
    end
  end
  -- Transform the snippets_table into completion_results
  for label, insertText in pairs(snippets_table) do
    table.insert(completion_results.items, {
      detail = desc or 'User Snippet',
      label = label,
      kind = vim.lsp.protocol.CompletionItemKind['Snippet'],
      documentation = {
        value = insertText,
        kind = vim.lsp.protocol.MarkupKind.Markdown,
      },
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
      insertText = insertText,
      sortText = 1.02, -- Ensure a low score by setting a high sortText value, not sure
    })
  end
  return completion_results
end

---@param completion_source table: The completion result to be returned by the server
---@return function: A function that creates a new server instance
local function new_server(completion_source)
  local function server(dispatchers)
    local closing = false
    local srv = {}
    function srv.request(method, params, handler)
      if method == 'initialize' then
        handler(nil, {
          capabilities = {
            completionProvider = {
              triggerCharacters = { '{', '(', '[', ' ', '}', ')', ']' },
            },
          },
        })
      elseif method == 'textDocument/completion' then
        handler(nil, completion_source)
      elseif method == 'shutdown' then
        handler(nil, nil)
      end
    end
    function srv.notify(method, _)
      if method == 'exit' then
        dispatchers.on_exit(0, 15)
      end
    end
    function srv.is_closing()
      return closing
    end
    function srv.terminate()
      closing = true
    end
    return srv
  end
  return server
end

---@param completion_source table: The completion source to be used by the mock
---LSP server
---@return number: The client ID of the started LSP client
function M.start_mock_lsp(completion_source)
  local server = new_server(completion_source)
  local dispatchers = {
    on_exit = function(code, signal)
      vim.notify('Server exited with code ' .. code .. ' and signal ' .. signal, vim.log.levels.ERROR)
    end,
  }
  local client_id = vim.lsp.start({
    name = 'sn_ls',
    cmd = server,
    root_dir = vim.loop.cwd(), -- not needed actually
    on_init = function(client)
      vim.notify('Snippet LSP server initialized', vim.log.levels.INFO)
    end,
    -- on_exit = function(code, signal)
    --   vim.notify('Snippet LSP server exited with code ' .. code .. ' and signal ' .. signal, vim.log.levels.ERROR)
    -- end,
  }, dispatchers)
  return client_id
end

return M
