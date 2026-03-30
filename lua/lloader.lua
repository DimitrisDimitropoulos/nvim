local group = vim.api.nvim_create_augroup('LazyPlugins', { clear = true })

local M = {}

---@param plugins (string|vim.pack.Spec)[]
function M.lazy_load(plugins)
  vim.pack.add(plugins, {
    confirm = false,
    load = function(plugin)
      local data = plugin.spec.data or {}

      -- Event trigger
      if data.event then
        vim.api.nvim_create_autocmd(data.event, {
          group = group,
          once = true,
          pattern = data.pattern or '*',
          callback = function()
            vim.cmd.packadd(plugin.spec.name)
            if data.config then
              data.config(plugin)
            end
          end,
        })
      end

      -- Command trigger
      if data.cmd then
        vim.api.nvim_create_user_command(data.cmd, function(cmd_args)
          pcall(vim.api.nvim_del_user_command, data.cmd)
          vim.cmd.packadd(plugin.spec.name)
          if data.config then
            data.config(plugin)
          end
          vim.api.nvim_cmd({
            cmd = data.cmd,
            args = cmd_args.fargs,
            bang = cmd_args.bang,
            nargs = cmd_args.nargs,
            range = cmd_args.range ~= 0 and { cmd_args.line1, cmd_args.line2 } or nil,
            count = cmd_args.count ~= -1 and cmd_args.count or nil,
          }, {})
        end, {
          nargs = data.nargs or '*',
          range = data.range,
          bang = data.bang,
          complete = data.complete,
          count = data.count,
        })
      end

      -- Keymap trigger
      if data.keys then
        local mode, lhs = data.keys[1], data.keys[2]
        vim.keymap.set(mode, lhs, function()
          vim.keymap.del(mode, lhs)
          vim.cmd.packadd(plugin.spec.name)
          if data.config then
            data.config(plugin)
          end
          vim.api.nvim_feedkeys(vim.keycode(lhs), 'm', false)
        end, { desc = data.desc })
      end
    end,
  })
end

vim.api.nvim_create_autocmd('PackChanged', {
  group = group,
  callback = function(event)
    local pkg = event.data
    local run_task = (pkg and pkg.spec and pkg.spec.data or {}).build
    -- Check if a 'build' function exists and the plugin wasn't deleted
    if pkg and pkg.kind ~= 'delete' and type(run_task) == 'function' then
      vim.cmd.packadd(pkg.spec.name)
      pcall(run_task, pkg)
    end
  end,
})

return M
