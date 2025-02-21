local M = {}

---@param entry table A list of entries with their text, line, and column information
---@param title string The title for the location list
function M.gen_loclist(entry, title)
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
      bufnr = vim.api.nvim_get_current_buf(),
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

---A unified function to capture nodes using a query string and language
---@param query_str string The Treesitter query string
---@param lang string The language of the Treesitter parser
---@return table entries list of entries with text, line, column, and file path
function M.get_entries(query_str, lang)
  local bufnr = vim.api.nvim_get_current_buf() ---@type number
  -- Check Neovim version
  if vim.version().minor < 11 then
    -- Use the old Treesitter approach
    local parser = vim.treesitter.get_parser(bufnr, lang) ---@type vim.treesitter.LanguageTree?
    if not parser then
      return {}
    end
    local root = parser:parse()[1]:root() ---@type TSTree
    local query = vim.treesitter.query.parse(lang, query_str)
    local entries = {}
    for _, match, _ in query:iter_matches(root, bufnr, 0, -1) do
      for _, node in pairs(match) do
        if node then
          local text = vim.treesitter.get_node_text(node, bufnr) or ''
          if text ~= '' then
            local line, col, _, _ = node:range()
            local entry = {
              text = text,
              line = line + 1,
              col = col + 1,
              path = vim.api.nvim_buf_get_name(0),
            }
            table.insert(entries, entry)
          end
        end
      end
    end
    return entries
  else
    -- Use the newer approach for 0.11+
    local parser = vim.treesitter.get_parser(bufnr, lang) ---@type vim.treesitter.LanguageTree?
    if not parser then
      return {}
    end
    local tree = parser:parse()[1]
    local root = tree:root() ---@type TSTree
    local query = vim.treesitter.query.parse(lang, query_str)
    local entries = {}
    for _, match, _ in query:iter_matches(root, bufnr, 0, -1) do
      for _, nodes in pairs(match) do
        for _, node in ipairs(nodes) do
          if node then
            local text = vim.treesitter.get_node_text(node, bufnr) or ''
            if text ~= '' then
              local line, col, _, _ = node:range()
              local entry = {
                text = text,
                line = line + 1,
                col = col + 1,
                path = vim.api.nvim_buf_get_name(0),
              }
              table.insert(entries, entry)
            end
          end
        end
      end
    end
    return entries
  end
end

return M
