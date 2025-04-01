vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('HighlightOnYank', { clear = true }),
  callback = function()
    vim.hl.on_yank { timeout = 230, higroup = 'Visual' }
  end,
  desc = 'highlight on yank',
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('GotoLastLoc', { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = 'last loc',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('SpellOn', { clear = true }),
  pattern = { 'gitcommit', 'markdown', 'tex', 'context', 'typst' },
  callback = function()
    vim.opt_local.spell = true
  end,
  desc = 'spell on specific filetypes',
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('MakeExecutable', { clear = true }),
  pattern = { '*.sh', '*.bash', '*.zsh' },
  callback = function()
    vim.fn.system('chmod +x ' .. vim.fn.expand '%')
  end,
  desc = 'make executable',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('TreesitterFolds', { clear = true }),
  desc = 'load treesitter folds later to copensate for async loading',
  callback = function(args)
    local bufnr = args.buf
    -- check if treesitter is available
    if pcall(vim.treesitter.start, bufnr) then
      vim.wo[0][0].foldmethod = 'expr'
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    else
      vim.wo[0][0].foldmethod = 'manual'
    end
  end,
})

local paths = {
  vim.fn.stdpath 'data' .. '/lazy/friendly-snippets/package.json',
  vim.fn.expand('$MYVIMRC'):match '(.*[/\\])' .. 'snippets/json_snippets/package.json',
}
local descs = { 'FR', 'USR' }
local sn_group = vim.api.nvim_create_augroup('SnippetServer', { clear = true })
vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  group = sn_group,
  once = true,
  callback = function()
    require('snippet').snippet_handler(paths, vim.bo.filetype, descs)
    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
      group = sn_group,
      callback = function()
        require('snippet').snippet_handler(paths, vim.bo.filetype, descs)
      end,
      desc = 'Handle LSP for buffer changes',
    })
  end,
})

if vim.fn.executable 'rg' == 1 then
  vim.api.nvim_create_user_command('Files', function(opts)
    local pattern = opts.args
    if pattern == '' then
      return vim.notify('No search pattern provided', vim.log.levels.WARN)
    end
    -- Construct the original piped command
    local cmd =
      string.format("rg --files --color=never --hidden --glob '!*.git' | rg --smart-case --color=never '%s'", pattern)
    -- Initialize pipes and result storage
    local stdout = vim.uv.new_pipe(false)
    local stderr = vim.uv.new_pipe(false)
    local results = {}
    -- Callback function when the process exits
    local function on_exit(code, signal)
      -- Nil checks before calling methods
      if stdout then
        stdout:read_stop()
        stdout:close()
      end
      if stderr then
        stderr:read_stop()
        stderr:close()
      end
      vim.schedule(function()
        if code > 1 then
          vim.notify('Error running rg: exit code ' .. code, vim.log.levels.WARN)
          return
        end
        if #results == 0 then
          if code == 1 then
            vim.notify('No matches found', vim.log.levels.INFO)
          else
            vim.notify('No matches found or an error occurred', vim.log.levels.WARN)
          end
          return
        end
        vim.ui.select(results, {
          prompt = string.format("Results for pattern: '%s'", pattern),
          format_item = function(item)
            return item
          end,
        }, function(choice)
          if choice then
            vim.cmd('edit ' .. choice)
          end
        end)
      end)
      if code > 1 then
        vim.schedule(function()
          vim.notify('Error running rg: exit code ' .. code, vim.log.levels.WARN)
        end)
      end
    end
    -- Spawn a shell to run the piped command
    local handle
    handle = vim.uv.spawn(tostring(vim.opt.shell._value), {
      args = { '-c', cmd },
      stdio = { nil, stdout, stderr },
    }, function(code, signal)
      handle:close()
      on_exit(code, signal)
    end)
    -- Read stdout and nil check before calling methods
    if not stdout then
      return
    end
    stdout:read_start(function(err, data)
      assert(not err, err)
      if data then
        for line in data:gmatch '[^\r\n]+' do
          table.insert(results, line)
        end
      end
    end)
    -- Read stderr and nil check before calling methods
    if not stderr then
      return
    end
    stderr:read_start(function(err, data)
      assert(not err, err)
      if data then
        vim.schedule(function()
          vim.notify('rg error: ' .. data, vim.log.levels.WARN)
        end)
      end
    end)
  end, {
    nargs = 1,
    desc = 'Search for files containing the specified pattern using ripgrep',
  })
else
  vim.notify("'rg' is not executable on this system", vim.log.levels.ERROR)
end
