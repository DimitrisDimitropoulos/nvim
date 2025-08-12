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

--- A unified function to capture nodes using a query string and language
--- @param query_str string The Treesitter query string
--- @param lang string The language of the Treesitter parser
--- @return table entries list of entries with text, line, column, and file path
function M.get_entries(query_str, lang)
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufnr, lang)
  if not parser then
    return {}
  end
  local entries = {}
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  local query = vim.treesitter.query.parse(lang, query_str)
  local root = parser:parse()[1]:root()
  local function process_node(node)
    if not node then
      return
    end
    local text = vim.treesitter.get_node_text(node, bufnr)
    if not text or text == '' then
      return
    end
    local line, col = node:range()
    entries[#entries + 1] = {
      text = text,
      line = line + 1,
      col = col + 1,
      path = filepath,
    }
  end
  for _, match, _ in query:iter_matches(root, bufnr, 0, -1) do
    for _, nodes in pairs(match) do
      for _, node in ipairs(nodes) do
        process_node(node)
      end
    end
  end
  return entries
end

return M
