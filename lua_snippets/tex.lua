--- @diagnostic disable: assigned-but-unused
local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

return {
  s(
    "lr",
    c(1, {
      sn(nil, { t "\\left(", i(1), t "\\right)" }),
      sn(nil, { t "\\left[", i(1), t "\\right]" }),
    })
  ),
}
