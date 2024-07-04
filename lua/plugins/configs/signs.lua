-- Do not load up plugin when in diff mode.
if vim.opt.diff:get() then
  return
end

local gitsigns_ok, gitsigns = pcall(require, 'gitsigns')
if not gitsigns_ok then
  return
end
local map = vim.keymap.set

gitsigns.setup {
  on_attach = function()
    local gs = package.loaded.gitsigns

    map('n', ',+', gs.stage_hunk, { desc = 'git stage hunk' })
    map('n', ',-', gs.reset_hunk, { desc = 'git reset hunk' })
    map('n', ',g', gs.preview_hunk, { desc = 'preview hunk' })
    map('n', ',b', function()
      gs.blame_line { full = true }
    end, { desc = 'git blame line' })
    map('n', ',r', gs.refresh, { desc = 'git refresh' })

    local git_nav = {
      { key = '[g', cmd = 'prev_hunk' },
      { key = ']g', cmd = 'next_hunk' },
    }
    for _, nav in ipairs(git_nav) do
      map('n', nav.key, function()
        if vim.wo.diff then
          return nav.key
        end
        gs[nav.cmd]()
      end, { desc = 'git ' .. nav.cmd })
    end

    map('n', '<leader>gf', function()
      local buffers = vim.api.nvim_list_bufs()
      local is_git_buf = false
      for _, buf in ipairs(buffers) do
        local filename = vim.api.nvim_buf_get_name(buf)
        if string.match(filename, '/%.git/') then
          is_git_buf = true
          vim.api.nvim_buf_delete(buf, { force = true })
          break
        end
      end
      if not is_git_buf then
        require('gitsigns').diffthis()
      end
    end, { desc = 'toggle git diff' })
  end,

  max_file_length = 1000,
  sign_priority = 1,
}
