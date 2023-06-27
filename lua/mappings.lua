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

-- Window management
keymapp(n, "<A-w>", "<C-w>w", opts)
keymapp(n, "<C-q>", "<C-w>q", opts)

--map c-d-u to autocenter with zz command
keymapp(n, "<C-d>", "<C-d>zz", opts)
keymapp(n, "<C-u>", "<C-u>zz", opts)

-- Save mappings
keymapp("i", "<C-s>", "<cmd> w <CR>", opts)
keymapp(n, "ZZ", "<cmd> wqa <CR>", opts)
keymapp(n, "ZQ", "<cmd> qa! <CR>", opts)

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

-- keymapp(n, "<leader>ff", "<cmd> Telescope find_files <CR>")
-- keymapp(n, "<leader>f;", "<cmd> Telescope commands <CR>", { desc = "find commands" }, opts)
-- keymapp(n, "<leader>lg", "<cmd> Telescope live_grep <CR>", { desc = "live grep" }, opts)
-- keymapp(n, "<leader>fs", "<cmd> Telescope grep_string <CR>", { desc = "" }, opts)
-- keymapp(n, "<leader>fb", "<cmd> Telescope buffers <CR>", { desc = "find buffers" }, opts)
-- keymapp(n, "<leader>fh", "<cmd> Telescope help_tags <CR>", { desc = "find help tags" }, opts)
-- keymapp(n, "<leader>fm", "<cmd> Telescope marks <CR>", { desc = "find marks" }, opts)
-- keymapp(n, "<leader>fr", "<cmd> Telescope oldfiles <CR>", { desc = "find old files" }, opts)
-- keymapp(n, "<leader>fk", "<cmd> Telescope keymaps <CR>", { desc = "find keymaps" }, opts)
-- keymapp(n, "<leader>re", "<cmd> Telescope registers <CR>", { desc = "find registers" }, opts)
-- keymapp(n, "<leader>re", "<cmd> Telescope registers <CR>", { desc = "find registers" }, opts)
-- keymapp(n, "<leader>fd", "<cmd> Telescope diagnostics <CR>", { desc = "find diagnostics" }, opts)
-- keymapp(n, "<leader>fm", "<cmd> Telescope marks <CR>", { desc = "find marks" }, opts)
-- keymapp(n, "<leader>ch", "<cmd> Telescope command_history <CR>", { desc = "find command history" }, opts)
-- keymapp(n, "<leader>ld", "<cmd> Telescope lsp_definitions <CR>", { desc = "find lsp definitions" }, opts)
-- keymapp(n, "<leader>sp", "<cmd> Telescope spell_suggest <CR>", { desc = "find spell suggestions" }, opts)
-- keymapp(n, "<leader>fz", "<cmd> Telescope current_buffer_fuzzy_find <CR>", { desc = "find current buffer fuzzy" }, opts)
-- keymapp(
--   n,
--   "<leader>ts",
--   "<cmd> Telescope treesitter default_text=function initial_mode=normal <CR>",
--   { desc = "find treesitter" },
--   opts
-- )
-- keymapp(
--   n,
--   "<leader>fa",
--   "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
--   { desc = "find all" },
--   opts
-- )
