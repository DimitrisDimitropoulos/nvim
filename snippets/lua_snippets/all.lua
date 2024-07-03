local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt

return {

  s(
    {
      trig = 'comm',
      name = 'Comment-Commons',
      dscr = 'Common comment formats',
    },
    fmt('{1}{2}, @{3}', {
      f(function()
        return vim.bo.commentstring:gsub('%%s', '')
      end),
      c(1, {
        sn(nil, { t 'TODO: ', i(1) }),
        sn(nil, { t 'FIXME: ', i(1) }),
        sn(nil, { t 'BUG: ', i(1) }),
        sn(nil, { t 'NOTE: ', i(1) }),
        sn(nil, { t 'HACK: ', i(1) }),
        sn(nil, { t 'OK: ', i(1) }),
        sn(nil, { t '', i(1) }),
      }),
      f(function()
        return os.date '%Y-%m-%d %H:%M:%S'
      end),
    })
  ),
}
