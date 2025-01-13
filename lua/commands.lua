local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end
local autocmd = vim.api.nvim_create_autocmd

autocmd('TextYankPost', {
  group = augroup 'YankHighlight',
  callback = function()
    vim.highlight.on_yank { timeout = 230, higroup = 'Visual' }
  end,
  desc = 'highlight on yank',
})

autocmd('BufReadPost', {
  group = augroup 'last_loc',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = 'last loc',
})

autocmd('FileType', {
  group = augroup 'close_with_q',
  pattern = { 'help', 'lspinfo', 'man', 'qf', 'query', 'checkhealth' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', function()
      vim.cmd.close {}
    end, { buffer = event.buf, silent = true })
  end,
  desc = 'close with q',
})

autocmd('FileType', {
  group = augroup 'spell',
  pattern = { 'gitcommit', 'markdown', 'tex', 'context' },
  callback = function()
    vim.opt_local.spell = true
  end,
  desc = 'spell on specific filetypes',
})

autocmd('BufWritePre', {
  group = augroup 'MakeExecutable',
  pattern = { '*.sh', '*.bash', '*.zsh' },
  callback = function()
    vim.fn.system('chmod +x ' .. vim.fn.expand '%')
  end,
  desc = 'make executable',
})

autocmd({ 'BufDelete', 'BufWipeout' }, {
  group = augroup 'WriteShaDa',
  command = 'wshada',
  desc = 'write deleted/wiped buffer to shada',
})

local sn_group = vim.api.nvim_create_augroup('SnippetServer', { clear = true })
-- Variable to track the last active LSP client ID
local last_client_id = nil
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  group = sn_group,
  callback = function()
    -- Stop the previous LSP client if it exists
    if last_client_id then
      -- vim.notify('Stopping previous LSP client: ' .. tostring(last_client_id))
      vim.lsp.stop_client(last_client_id)
      last_client_id = nil
    end
    -- Delay to ensure the previous server has fully stopped before starting a new one
    vim.defer_fn(function()
      -- paths table
      local pkg_path_fr = vim.fn.stdpath 'data' .. '/lazy/friendly-snippets/package.json'
      local paths = require('snippet').parse_pkg(pkg_path_fr, vim.bo.filetype)
      local usr_paths = require('snippet').parse_pkg(
        vim.fn.expand('$MYVIMRC'):match '(.*[/\\])' .. 'snippets/json_snippets/package.json',
        vim.bo.filetype
      )
      table.insert(paths, usr_paths[1])
      if not paths or #paths == 0 then
        -- vim.notify('No snippets found for filetype: ' .. vim.bo.filetype, vim.log.levels.WARN)
        return
      end
      -- Concat all the snippets from all the paths
      local all_snippets = { isIncomplete = false, items = {} }
      for _, snips_path in ipairs(paths) do
        local snips = require('snippet').read_file(snips_path)
        local lsp_snip = require('snippet').process_snippets(snips, 'USR')
        if lsp_snip and lsp_snip.items then
          for _, snippet_item in ipairs(lsp_snip.items) do
            table.insert(all_snippets.items, snippet_item)
          end
        end
      end
      -- Start the new mock LSP server
      local client_id = require('snippet').start_mock_lsp(all_snippets)
      if client_id then
        vim.notify('Started new LSP client with ID: ' .. tostring(client_id))
      end
      -- Store the new client ID for future buffer changes
      last_client_id = client_id
    end, 500) -- 500ms delay to ensure clean server shutdown
  end,
  desc = 'Handle LSP for buffer changes',
})

if false then
  local ffi = require 'ffi'
  ffi.cdef [[
  typedef int32_t linenr_T;
  char *ml_get(linenr_T lnum);
  bool pum_visible(void);
  ]]
  local pumvisible = ffi.C.pum_visible

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client or not client:supports_method 'textDocument/completion' then
        return
      end
      vim.lsp.completion.enable(true, client.id, bufnr, {
        autotrigger = true,
        convert = function(item)
          return { abbr = item.label:gsub('%b()', ''), kind = '' }
        end,
      })
      vim.api.nvim_create_autocmd('InsertCharPre', {
        buffer = bufnr,
        callback = function()
          if pumvisible() then
            return
          end
          local triggerchars = vim.tbl_get(client, 'server_capabilities', 'completionProvider', 'triggerCharacters')
            or {}
          if vim.v.char:match '[%w_]' and not vim.list_contains(triggerchars, vim.v.char) then
            vim.lsp.completion.trigger()
          end
        end,
      })
    end,
  })
end

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
        -- Prepare the quickfix list
        local qf_list = {}
        for _, line in ipairs(results) do
          table.insert(qf_list, { filename = line })
        end
        -- Set the quickfix list with the results
        vim.fn.setqflist(qf_list, 'r')
        -- Set additional options like the title
        vim.fn.setqflist({}, 'a', { title = string.format("Results for pattern: '%s'", pattern) })
        -- Open the quickfix window
        vim.cmd 'copen'
        -- Resize the quickfix window if there are fewer than 10 results
        if #results < 10 then
          vim.cmd('resize ' .. #results)
        end
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
