local comment = require "Comment"
local map = vim.keymap.set
local opts = {
  noremap = true,
  silent = false,
}
local n = "n"

comment.setup {

  map(
    n,
    "<leader>/",
    function() require("Comment.api").toggle.linewise.current() end,
    { desc = "comment line" },
    opts
  ),

  map("v", "<leader>/", function()
    local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
    vim.api.nvim_feedkeys(esc, "x", false)
    require("Comment.api").toggle.linewise(vim.fn.visualmode())
  end, { desc = "comment in visual mode" }),

  -- map(
  --   "v",
  --   "<leader>/",
  --   "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  --   opts
  -- )
}
