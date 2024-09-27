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

if false then
  vim.api.nvim_create_autocmd('InsertEnter', {
    group = vim.api.nvim_create_augroup('snippet_compl', { clear = true }),
    callback = function()
      -- keymaps
      vim.keymap.set({ 'i', 's' }, '<A-j>', function()
        if vim.snippet.active { direction = 1 } then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
          return
        end
      end, { silent = true })
      vim.keymap.set({ 'i', 's' }, '<A-k>', function()
        if vim.snippet.active { direction = -1 } then
          vim.schedule(function()
            vim.snippet.jump(-1)
          end)
          return
        end
      end, { silent = true })

      -- paths table
      local pkg_path_fr = vim.fn.stdpath 'data' .. '/lazy/friendly-snippets/package.json' ---@type string
      local paths = require('snippet').parse_pkg(pkg_path_fr, vim.bo.filetype) ---@type table<string>
      local usr_paths = require('snippet').parse_pkg(
        vim.fn.expand('$MYVIMRC'):match '(.*[/\\])' .. 'snippets/json_snippets/package.json',
        vim.bo.filetype
      ) ---@type table<string>
      table.insert(paths, usr_paths[1])

      -- create all the snippets from all the paths
      local all_snippets = { isIncomplete = false, items = {} } -- Initialize the table for merged snippets
      for _, snips_path in ipairs(paths) do
        local snips = require('snippet').read_file(snips_path)
        local lsp_snip = require('snippet').process_snippets(snips, 'USR')
        -- Merge the processed snippets (lsp_snip) into all_snippets
        if lsp_snip and lsp_snip.items then
          for _, snippet_item in ipairs(lsp_snip.items) do
            table.insert(all_snippets.items, snippet_item)
          end
        end
      end

      -- fire up the mock lsp
      require('snippet').start_mock_lsp(all_snippets)
    end,
    desc = 'completion groups',
  })
end
