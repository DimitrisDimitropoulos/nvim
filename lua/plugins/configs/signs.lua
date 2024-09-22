-- Do not load up plugin when in diff mode.
if vim.opt.diff:get() then return end

local gitsigns = require "gitsigns"
local feedkeys = vim.api.nvim_feedkeys
local map = vim.keymap.set
local schedule = vim.schedule
local opts = {
  noremap = true,
  silent = false,
}
local n = "n"

gitsigns.setup {
  on_attach = function()
    local gs = package.loaded.gitsigns

    map(n, "'+", gs.stage_hunk)
    map(n, "'-", gs.reset_hunk)
    map(n, "'g", gs.preview_hunk)
    map(n, "'b", function() gs.blame_line { full = true } end)
    map(n, "'r", gs.refresh)

    local git_nav = {
      { key = "[g", cmd = "prev_hunk" },
      { key = "]g", cmd = "next_hunk" },
    }
    for _, nav in ipairs(git_nav) do
      map(n, nav.key, function()
        if vim.wo.diff then return nav.key end
        schedule(function() gs[nav.cmd]() end)
        schedule(function() feedkeys("zz", "n", false) end)
        return "<Ignore>"
      end, { desc = "git " .. nav.cmd }, opts)
    end

    map(n, "<leader>gf", function()
      local buffers = vim.api.nvim_list_bufs()
      local is_git_buf = false
      for _, buf in ipairs(buffers) do
        local filename = vim.api.nvim_buf_get_name(buf)
        if string.match(filename, "/%.git/") then
          is_git_buf = true
          vim.api.nvim_buf_delete(buf, { force = true })
          break
        end
      end
      if not is_git_buf then require("gitsigns").diffthis() end
    end, { desc = "toggle git diff" }, opts)
  end,

  max_file_length = 1000,
  sign_priority = 6,
}
