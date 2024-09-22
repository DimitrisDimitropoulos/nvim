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
    })
  ),

  s({
    trig = "sepcomm",
    name = "Comment-Separate",
    dscr = "Separate with commentstring",
  }, f(sn_ut.separate_with_commentstring)),

  s({
    trig = "sepeq",
    name = "Equals-Separate",
    dscr = "Separate with equals",
  }, f(sn_ut.separate_with_equals)),

  s(
    {
      trig = "titlesep",
      name = "Title-Separate",
      dscr = "Separate with title",
    },
    fmt("{}\n{} {} {}\n{}", {
      f(sn_ut.separate_with_equals),
      f(sn_ut.get_comment_string),
      i(1, "Title"),
      f(sn_ut.get_comment_string),
      f(sn_ut.separate_with_equals),
    })
  ),

  s("time", p(vim.fn.strftime, "%H:%M:%S")),
  s("shrug", { t "¯\\_(ツ)_/¯" }),
  s("lenny", { t "( ͡° ͜ʖ ͡°)" }),
  s("tableflip", { t "(╯°□°）╯︵ ┻━┻" }),
  s("tableback", { t "┬─┬ ノ( ゜-゜ノ)" }),
  s("happy", { t "ヽ(´▽`)/" }),
  s("sad", { t "(╥_╥)" }),
  s("confused", { t "(｡･ω･｡)" }),
}
