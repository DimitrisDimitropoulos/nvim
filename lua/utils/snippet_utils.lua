local M = {}

function M.get_comment_string()
  if vim.bo.filetype == 'cpp' then return '//' end
  if vim.bo.filetype == 'c' then return '//' end
  local commentstring = vim.bo.commentstring
  if commentstring == nil or commentstring == '' then return 'There is no commentstring set' end
  return commentstring:gsub('%%s', '')
end

function M.separate_with_commentstring()
  local commentstring = tostring(M.get_comment_string())
  -- remove trailing whitespace
  commentstring = commentstring:gsub('%s+$', '')
  if #commentstring == 1 then return commentstring .. string.rep(commentstring, 79) end
  return commentstring .. string.rep(commentstring, 39)
  -- NOTE: lua numbering begins @1, @2023-07-24 17:13:23
end

function M.separate_with_equals()
  local commentstring = tostring(M.get_comment_string())
  -- remove trailing whitespace
  commentstring = commentstring:gsub('%s+$', '')
  if #commentstring == 1 then return commentstring .. ' ' .. string.rep('=', 78) end
  return commentstring .. ' ' .. string.rep('=', 77)
end

-- =============================================================================
-- -- Unused yet but unsubtly useful --
-- =============================================================================

function M.get_indentation()
  local line = vim.api.nvim_get_current_line()
  local col = unpack(vim.api.nvim_win_get_cursor(0))
  local indentation = line:sub(1, col):match '^%s+'
  if indentation == nil then return 0 end
  return #indentation
end

return M
