local keymapp = vim.keymap.set
local opts = {
  noremap = true,
  silent = false,
}
local n = "n"

-- general mappings
keymapp(n, "<C-s>", "<cmd> w <CR>")
keymapp(n, "<ESC>", "<cmd> nohl <CR>", { desc = "clear search" }, opts)

-- comment.nvim
keymapp(n, "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end)
keymapp("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")

-- bufferline alternative
keymapp(n, "<TAB>", "<cmd> bnext<CR>", { desc = "next buffer" }, opts)
keymapp(n, "<S-Tab>", "<cmd> bprevious<CR>", { desc = "previous buffer" }, opts)
keymapp(n, "<leader>bd", "<cmd> bd<CR>", { desc = "delete buffer" }, opts)
keymapp(n, "<leader>bn", "<cmd> enew <CR>", { desc = "buffer new" }, opts)

--map c-d-u to autocenter with zz command
keymapp(n, "<C-d>", "<C-d>zz", opts)
keymapp(n, "<C-u>", "<C-u>zz", opts)

-- Diagnostic mappings
keymapp(n, "<leader>df", vim.diagnostic.open_float, { desc = "diagnostics float" })
keymapp(n, "[d", vim.diagnostic.goto_prev, { desc = "diagnostics prev" }, opts)
keymapp(n, "]d", vim.diagnostic.goto_next, { desc = "diagnostics next" }, opts)

-- Save mappings
keymapp("i", "<C-s>", "<cmd> w <CR>", opts)
keymapp(n, "ZZ", "<cmd> wqa <CR>", opts)
keymapp(n, "ZQ", "<cmd> qa! <CR>", opts)

-- Window management
local windows = {
  { key = "<A-w>", cmd = "w" },
  { key = "<C-q>", cmd = "q" },
  { key = "<C-h>", cmd = "h" },
  { key = "<C-j>", cmd = "j" },
  { key = "<C-k>", cmd = "k" },
  { key = "<C-l>", cmd = "l" },
}
for _, window in ipairs(windows) do
  keymapp(n, window.key, "<C-w>" .. window.cmd, { desc = "window " .. window.cmd }, opts)
end

-- Telescope
local telescope_mappings = {
  { key = "ff", cmd = "find_files",                                            desc = "files" },
  { key = "f;", cmd = "commands",                                              desc = "commands" },
  { key = "lg", cmd = "live_grep",                                             desc = "live grep" },
  { key = "fs", cmd = "grep_string",                                           desc = "string mark" },
  { key = "fb", cmd = "buffers",                                               desc = "buffers" },
  { key = "fh", cmd = "help_tags",                                             desc = "help tags" },
  { key = "fm", cmd = "marks",                                                 desc = "marks" },
  { key = "fr", cmd = "oldfiles",                                              desc = "old files" },
  { key = "fk", cmd = "keymaps",                                               desc = "keymaps" },
  { key = "re", cmd = "registers",                                             desc = "registers" },
  { key = "fd", cmd = "diagnostics",                                           desc = "diagnostics" },
  { key = "ch", cmd = "command_history",                                       desc = "command history" },
  { key = "ld", cmd = "lsp_definitions",                                       desc = "lsp definitions" },
  { key = "sp", cmd = "spell_suggest",                                         desc = "spell suggestions" },
  { key = "fz", cmd = "current_buffer_fuzzy_find",                             desc = "current buffer fuzzy" },
  { key = "ts", cmd = "treesitter default_text=function initial_mode=normal ", desc = "treesitter" },
  { key = "fa", cmd = "find_files follow=true no_ignore=true hidden=true ",    desc = "hidden" },
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
