local keymapp = vim.keymap.set
local opts = {
  noremap = true,
  silent = false,
}
local n = "n"

-- Save mappings
keymapp({ "i", "n" }, "<C-s>", "<cmd> w <CR>", opts)

-- Command mappings
local commands = {
  { key = "<ESC>",      cmd = "nohl",      descr = "clear search" },
  { key = "<TAB>",      cmd = "bnext",     descr = "next buffer" },
  { key = "<S-Tab>",    cmd = "bprevious", descr = "previous buffer" },
  { key = "<leader>bd", cmd = "bd",        descr = "delete buffer" },
  { key = "<leader>bn", cmd = "enew",      descr = "buffer new" },
  { key = "<ZZ>",       cmd = "wqa",       descr = "save and quit" },
  { key = "<ZQ>",       cmd = "qa!",       descr = "quit without saving" },
}
for _, command in ipairs(commands) do
  keymapp(n, command.key, "<cmd> " .. command.cmd .. " <CR>", { desc = command.descr }, opts)
end

-- Diagnostic mappings
local diagno = {
  { key = "<leader>df", cmd = "open_float", descr = "diagnostics float" },
  { key = "[d",         cmd = "goto_prev",  descr = "diagnostics prev" },
  { key = "]d",         cmd = "goto_next",  descr = "diagnostics next" },
}
for _, diag in ipairs(diagno) do
  keymapp(n, diag.key, vim.diagnostic[diag.cmd], { desc = diag.descr }, opts)
end

-- Window management
local window = { "w", "q", "h", "j", "k", "l" }
for _, win in ipairs(window) do
  keymapp(n, "<C-" .. win .. ">", "<C-w>" .. win, { desc = "window " .. win }, opts)
end

--   ----------------
-- | Plugin mappings |
-- ----------------

-- Telescope
local telescope_mappings = {
  { key = "ff", cmd = "fd",                                                   desc = "files" },
  { key = "f;", cmd = "commands",                                             desc = "commands" },
  { key = "lg", cmd = "live_grep",                                            desc = "live grep" },
  { key = "fs", cmd = "grep_string",                                          desc = "string mark" },
  { key = "fb", cmd = "buffers",                                              desc = "buffers" },
  { key = "fh", cmd = "help_tags",                                            desc = "help tags" },
  { key = "fm", cmd = "marks",                                                desc = "marks" },
  { key = "fr", cmd = "oldfiles",                                             desc = "old files" },
  { key = "fk", cmd = "keymaps",                                              desc = "keymaps" },
  { key = "re", cmd = "registers",                                            desc = "registers" },
  { key = "fd", cmd = "diagnostics",                                          desc = "diagnostics" },
  { key = "ch", cmd = "command_history",                                      desc = "command history" },
  { key = "ld", cmd = "lsp_definitions",                                      desc = "lsp definitions" },
  { key = "sp", cmd = "spell_suggest",                                        desc = "spell suggestions" },
  { key = "fz", cmd = "current_buffer_fuzzy_find",                            desc = "current buffer fuzzy" },
  { key = "ts", cmd = "treesitter default_text=function initial_mode=normal", desc = "treesitter" },
  { key = "fa", cmd = "find_files follow=true no_ignore=true hidden=true",    desc = "hidden" },
}
for _, mapping in ipairs(telescope_mappings) do
  keymapp(
    n,
    "<leader>" .. mapping.key,
    "<cmd> Telescope " .. mapping.cmd .. " <CR>",
    { desc = "find " .. mapping.desc },
    opts
  )
end

-- NvimTree
keymapp(n, "<C-b>", "<cmd> NvimTreeToggle <CR>", { desc = "toggle nvimtree" }, opts)

-- comment.nvim
keymapp(n, "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end)
keymapp("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")
