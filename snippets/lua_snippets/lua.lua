local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local extras = require 'luasnip.extras'
local l = extras.lambda
local fmt = require('luasnip.extras.fmt').fmt

return {
  s(
    {
      trig = 'req',
      name = 'require module',
      dscr = 'require module auto variable name',
    },
    fmt('local {} = require("{}")', {
      l(l._1:match('[^.]*$'):gsub('[^%a]+', '_'), 1),
      i(1, 'module'),
    })
  ),

  s(
    {
      trig = 'pcall',
      name = 'pcall require module',
      dscr = 'pcall require module auto variable name',
    },
    fmt('local {1}_ok, {1} = pcall(require, "{}")\nif not {1}_ok then return end', {
      l(l._1:match('[^.]*$'):gsub('[^%a]+', '_'), 1),
      i(1, 'module'),
    }),
    { descrition = 'pcall module' }
  ),
}
