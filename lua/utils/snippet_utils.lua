local M = {}

function M.get_comment_string()
  local commentstring = vim.bo.commentstring
  if commentstring == nil or commentstring == "" then return "There is no commentstring set" end
  return commentstring:gsub("%%s", "")
end

function M.separate_with_commentstring()
  local commentstring = tostring(M.get_comment_string())
  -- remove trailing whitespace
  commentstring = commentstring:gsub("%s+$", "")
  if #commentstring == 1 then return commentstring .. string.rep(commentstring, 79) end
  return commentstring .. string.rep(commentstring, 39)
  -- NOTE: lua numbering begins @1, @2023-07-24 17:13:23
end

function M.separate_with_equals()
  local commentstring = tostring(M.get_comment_string())
  -- remove trailing whitespace
  commentstring = commentstring:gsub("%s+$", "")
  if #commentstring == 1 then return commentstring .. " " .. string.rep("=", 78) end
  return commentstring .. " " .. string.rep("=", 77)
end

function M.center_word(word)
  word = tostring(word)
  -- i want to center a word
  local commentstring = tostring(M.get_comment_string())
  -- remove trailing whitespace
  commentstring = commentstring:gsub("%s+$", "")
  if #commentstring == 1 then
    local len = 1 * math.floor((79 - #word) / 2) - 3
    return commentstring .. " " .. string.rep("=", len) .. word .. string.rep("=", len)
  end
  local len = 1 * math.floor((77 - #word) / 2) - 4
  return commentstring .. " " .. string.rep("=", len) .. " " .. word .. " " .. string.rep("=", len)
end

return M
