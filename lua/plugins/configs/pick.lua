vim.cmd.packadd 'mini.extra'

local pick = require 'mini.pick'
local extra = require 'mini.extra'

local function has_executable(name)
  if vim.fn.executable(name) == 1 then
    return true
  end
  vim.notify(string.format('`%s` is required for this picker', name), vim.log.levels.WARN)
  return false
end

local function files()
  if not has_executable 'rg' then
    return
  end
  return pick.builtin.cli({
    command = {
      'rg',
      '--files',
      '--smart-case',
      '--color=never',
      '--follow',
      '--glob',
      '!.git',
      '--glob',
      '!build',
      '--glob',
      '!spell',
    },
  }, { source = { name = 'Files (rg)' } })
end

local function files_all()
  if not has_executable 'rg' then
    return
  end
  return pick.builtin.cli({
    command = { 'rg', '--files', '--hidden', '-u', '--glob', '!.git' },
  }, { source = { name = 'Files (rg, all)' } })
end

local function git_status()
  if not has_executable 'git' then
    return
  end

  local root = vim.fs.root(vim.fn.getcwd(), '.git')
  if root == nil then
    vim.notify('(mini.pick) not inside a Git repository', vim.log.levels.WARN)
    return
  end

  return pick.builtin.cli({
    command = { 'git', '-C', root, 'status', '--porcelain=v1' },
    postprocess = function(lines)
      local items = {}
      for _, line in ipairs(lines) do
        local path = line:sub(4)
        if path ~= '' then
          path = path:match '.* %-> (.*)$' or path
          path = path:match '^"(.*)"$' or path
          table.insert(items, { text = line, path = vim.fs.joinpath(root, path) })
        end
      end
      return items
    end,
  }, { source = { name = 'Git status', cwd = root } })
end

for _, mapping in ipairs {
  { key = 'ff', func = files, desc = 'Find files' },
  { key = 'fa', func = files_all, desc = 'Find all files' },
  { key = 'fr', func = extra.pickers.oldfiles, desc = 'Find recent files' },
  { key = 'f;', func = extra.pickers.commands, desc = 'Find commands' },
  {
    key = 'fg',
    func = function()
      return pick.builtin.grep_live { globs = { '!.git', '!build', '!spell' } }
    end,
    desc = 'Live grep',
  },
  { key = 'fb', func = pick.builtin.buffers, desc = 'Find buffers' },
  { key = 'fh', func = pick.builtin.help, desc = 'Find help tags' },
  {
    key = 'f/',
    func = function()
      return extra.pickers.history { scope = '/' }
    end,
    desc = 'Search history',
  },
  { key = 'fm', func = extra.pickers.marks, desc = 'Find marks' },
  { key = 'fk', func = extra.pickers.keymaps, desc = 'Find keymaps' },
  { key = 'fe', func = extra.pickers.registers, desc = 'Find registers' },
  {
    key = 'fd',
    func = function()
      return extra.pickers.diagnostic { scope = 'current' }
    end,
    desc = 'Diagnostics (buffer)',
  },
  {
    key = 'fD',
    func = function()
      return extra.pickers.diagnostic { scope = 'all' }
    end,
    desc = 'Diagnostics (workspace)',
  },
  {
    key = 'fc',
    func = function()
      return extra.pickers.history { scope = ':' }
    end,
    desc = 'Command history',
  },
  {
    key = 'fl',
    func = function()
      return extra.pickers.lsp { scope = 'document_symbol' }
    end,
    desc = 'LSP document symbols',
  },
  {
    key = 'fw',
    func = function()
      return extra.pickers.lsp { scope = 'workspace_symbol_live' }
    end,
    desc = 'LSP workspace symbols',
  },
  { key = 'f.', func = pick.builtin.resume, desc = 'Resume picker' },
  { key = 'ft', func = git_status, desc = 'Git status' },
  {
    key = 'fq',
    func = function()
      return extra.pickers.list { scope = 'quickfix' }
    end,
    desc = 'Quickfix list',
  },
  {
    key = 'fv',
    func = function()
      return extra.pickers.list { scope = 'location' }
    end,
    desc = 'Location list',
  },
} do
  vim.keymap.set('n', '<leader>' .. mapping.key, mapping.func, { desc = 'MiniPick ' .. mapping.desc })
end

pick.setup {
  source = { show = pick.default_show },
  window = {
    config = function()
      local height = math.floor(0.75 * vim.o.lines)
      local width = math.floor(0.8 * vim.o.columns)
      return {
        anchor = 'NW',
        height = height,
        width = width,
        row = math.floor(0.5 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
      }
    end,
  },
}

extra.setup {}
