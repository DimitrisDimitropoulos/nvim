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

local sn_ut = require "utils.snippet_utils"

return {

  s(
    {
      trig = "comm",
      name = "Comment-Commons",
      dscr = "Common comment formats",
    },
    fmt("{1}{2}, @{3}", {
      f(sn_ut.get_comment_string),
      c(1, {
        sn(nil, { t "TODO: ", i(1) }),
        sn(nil, { t "FIXME: ", i(1) }),
        sn(nil, { t "BUG: ", i(1) }),
        sn(nil, { t "NOTE: ", i(1) }),
        sn(nil, { t "HACK: ", i(1) }),
        sn(nil, { t "OK: ", i(1) }),
        sn(nil, { t "", i(1) }),
      }),
      f(function() return os.date "%Y-%m-%d %H:%M:%S" end),
    }),
    { description = "Comment" }
  ),

  s({
    trig = "separate",
    name = "Comment-Separate",
    dscr = "Separate with commentstring",
  }, f(sn_ut.separate_with_commentstring)),

  s("time", p(vim.fn.strftime, "%H:%M:%S")),
  s("shrug", { t "¯\\_(ツ)_/¯" }),
  s("angry", { t "(╯°□°）╯" }),
  s("happy", { t "ヽ(´▽`)/" }),
  s("sad", { t "(－‸ლ)" }),
  s("confused", { t "(｡･ω･｡)" }),
}
