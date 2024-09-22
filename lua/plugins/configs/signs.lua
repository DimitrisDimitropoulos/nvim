-- Do not load up plugin when in diff mode.
if vim.opt.diff:get() then
  return
end

local gitsigns_ok, gitsigns = pcall(require, 'gitsigns')
if not gitsigns_ok then
  return
end

gitsigns.setup {
  on_attach = function()
    local gs = package.loaded.gitsigns

    vim.keymap.set('n', ',+', gs.stage_hunk, { desc = 'git stage hunk' })
    vim.keymap.set('n', ',-', gs.reset_hunk, { desc = 'git reset hunk' })
    vim.keymap.set('n', ',g', gs.preview_hunk, { desc = 'preview hunk' })
    vim.keymap.set('n', ',b', function()
      gs.blame_line { full = true }
    end, { desc = 'git blame line' })
    vim.keymap.set('n', ',r', gs.refresh, { desc = 'git refresh' })

    for _, nav in ipairs {
      { key = '[g', cmd = 'prev_hunk' },
      { key = ']g', cmd = 'next_hunk' },
    } do
      vim.keymap.set('n', nav.key, function()
        if vim.wo.diff then
          return nav.key
        end
        gs[nav.cmd]()
      end, { desc = 'git ' .. nav.cmd })
    end

    vim.keymap.set('n', '<leader>gf', function()
      local is_git_buf = false
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
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
