--- @diagnostic disable: assigned-but-unused
local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local extras = require "luasnip.extras"
local p = extras.partial
local fmt = require("luasnip.extras.fmt").fmt

local function get_comment_string()
  local commentstring = vim.bo.commentstring
  if commentstring == nil or commentstring == "" then
    return "There is no commentstring set"
  end
  return commentstring:gsub("%%s", "")
end

-- now i want to append 80 times this character
local function separate_with_commentstring()
  local commentstring = get_comment_string()
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

return {

  s(
    {
      trig = "comm",
      name = "Comment-Commons",
      dscr = "Common comment formats",
    },
    fmt("{1}{2}, @{3}", {
      f(get_comment_string),
      c(1, {
        sn(nil, { t "TODO: ", i(1) }),
        sn(nil, { t "FIXME: ", i(1) }),
        sn(nil, { t "BUG: ", i(1) }),
        sn(nil, { t "NOTE: ", i(1) }),
        sn(nil, { t "HACK: ", i(1) }),
        sn(nil, { t "OK: ", i(1) }),
        sn(nil, { t "", i(1) }),
      }),
      f(function( --[[ args ]]) return os.date "%Y-%m-%d %H:%M:%S" end),
    }),
    { description = "Comment" }
  ),

  s({
    trig = "separate",
    name = "Comment-Separate",
    dscr = "Separate with commentstring",
  }, f(separate_with_commentstring)),

  s("time", p(vim.fn.strftime, "%H:%M:%S")),
  s("shrug", { t "¯\\_(ツ)_/¯" }),
  s("angry", { t "(╯°□°）╯" }),
  s("happy", { t "ヽ(´▽`)/" }),
  s("sad", { t "(－‸ლ)" }),
  s("confused", { t "(｡･ω･｡)" }),
}
