local map = vim.keymap.set
local opts = {
  noremap = true,
  silent = false,
}

local n = "n"

-- Save mappings there are problems
vim.keymap.set({ "i", "n" }, "<C-s>", ": w <CR>")
-- vim.keymap.set("n", "<leader>zz", ": wqa <CR>")
-- vim.keymap.set("n", "<leader>zq", ": wq! <CR>")
-- vim.keymap.set("n", "ZQ", ": wq! <CR>")
-- vim.keymap.set("n", "ZZ", ": wqa <CR>")
-- Increasing the timeoutlen to 300ms
-- helps with stabillity when slow
vim.keymap.set("n", "ZZ", function()
  vim.o.timeout = true
  vim.o.timeoutlen = 300
  vim.cmd "wqa"
end, { desc = "save and quit", silent = false })
vim.keymap.set("n", "ZQ", function()
  vim.o.timeout = true
  vim.o.timeoutlen = 300
  vim.cmd "qa!"
end, { desc = "quit with no save", silent = false })

-- Command mappings
local commands = {
  { key = "<ESC>",      cmd = "nohl",      descr = "clear search" },
  { key = "<TAB>",      cmd = "bnext",     descr = "next buffer" },
  { key = "<S-Tab>",    cmd = "bprevious", descr = "previous buffer" },
  { key = "<leader>bd", cmd = "bd",        descr = "delete buffer" },
  { key = "<leader>bn", cmd = "enew",      descr = "buffer new" },
}
for _, command in ipairs(commands) do
  map(
    n,
    command.key,
    "<cmd> " .. command.cmd .. " <CR>",
    { desc = command.descr },
    opts
  )
end

-- Diagnostic mappings
local diagno = {
  { key = "<leader>df", cmd = "open_float", descr = "diagnostics float" },
  { key = "[d",         cmd = "goto_prev",  descr = "diagnostics prev" },
  { key = "]d",         cmd = "goto_next",  descr = "diagnostics next" },
}
for _, diag in ipairs(diagno) do
  map(n, diag.key, vim.diagnostic[diag.cmd], { desc = diag.descr }, opts)
end

-- Window management
local window = { "w", "q", "h", "j", "k", "l" }
for _, win in ipairs(window) do
  map(n, "<C-" .. win .. ">", "<C-w>" .. win, { desc = "window " .. win }, opts)
end

-- -------------------
-- - Plugin mappings -
-- -------------------
-- note: prefer using the plugin's api
-- instead of the cmd route

-- Telescope
local telescope_mappings = {
  { key = "ff", cmd = "fd",              desc = "files" },
  { key = "fr", cmd = "oldfiles",        desc = "old files" },
  { key = "f;", cmd = "commands",        desc = "commands" },
  { key = "lg", cmd = "live_grep",       desc = "live grep" },
  { key = "fs", cmd = "grep_string",     desc = "string mark" },
  { key = "fb", cmd = "buffers",         desc = "buffers" },
  { key = "fh", cmd = "help_tags",       desc = "help tags" },
  { key = "fm", cmd = "marks",           desc = "marks" },
  { key = "fk", cmd = "keymaps",         desc = "keymaps" },
  { key = "re", cmd = "registers",       desc = "registers" },
  { key = "fd", cmd = "diagnostics",     desc = "diagnostics" },
  { key = "ch", cmd = "command_history", desc = "command history" },
  { key = "ld", cmd = "lsp_definitions", desc = "lsp definitions" },
  { key = "sp", cmd = "spell_suggest",   desc = "spell suggestions" },
  {
    key = "fz",
    cmd = "current_buffer_fuzzy_find",
    desc = "current buffer fuzzy",
  },
}
for _, mapping in ipairs(telescope_mappings) do
  map(n, "<leader>" .. mapping.key, function()
    require("telescope.builtin")[mapping.cmd]()
  end, { desc = "find " .. mapping.desc }, opts)
end

map(n, "<leader>ts", function()
  require("telescope.builtin").treesitter { default_text = "function" }
end, { desc = "find treesitter" }, opts)
map(n, "<leader>fa", function()
  require("telescope.builtin").find_files {
    hidden = true,
    follow = true,
    no_ignore = true,
    file_ignore_patterns = { ".git" },
  }
end, { desc = "find files" }, opts)

-- NvimTree
map(n, "<C-b>", function()
  require("nvim-tree.api").tree.toggle()
end, { desc = "toggle nvimtree" }, opts)

-- Comment
map(n, "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "comment line" }, opts)

-- map(
--   "v",
--   "<leader>/",
--   "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
--   opts
-- )

map("v", "<leader>/", function()
  local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "comment in visual mode" })

-- Trouble
map(n, "<leader>tr", function()
  require("trouble").toggle()
end, { desc = "trouble" }, opts)

-- Gitsigns
local git_nav = {
  { key = "[g", cmd = "prev_hunk" },
  { key = "]g", cmd = "next_hunk" },
}
for _, nav in ipairs(git_nav) do
  map(n, nav.key, function()
    local gs = package.loaded.gitsigns
    if vim.wo.diff then
      return nav.key
    end
    vim.schedule(function()
      gs[nav.cmd]()
    end)
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
  if not is_git_buf then
    require("gitsigns").diffthis()
  end
end, { desc = "toggle git diff" }, opts)
