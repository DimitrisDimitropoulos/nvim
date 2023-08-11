local M = {}

function M.get_comment_string()
  local commentstring = vim.bo.commentstring
  if commentstring == nil or commentstring == "" then
    return "There is no commentstring set"
  end
  return commentstring:gsub("%%s", "")
end

-- now i want to append 80 times this character
function M.separate_with_commentstring()
  local commentstring = tostring(M.get_comment_string())
  -- remove trailing whitespace
  commentstring = commentstring:gsub("%s+$", "")
  -- check the number of characters in order to
  -- append the correct amount
  if #commentstring == 1 then
    return commentstring .. string.rep(commentstring, 79)
  end
  return commentstring .. string.rep(commentstring, 39)
  -- NOTE: lua numbering begins @1, @2023-07-24 17:13:23
end

return M
