local map = vim.keymap.set

-- Save mappings there are problems
vim.keymap.set({ "i", "n" }, "<C-s>", ": w <CR>")
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

-- exit terminal mode
map("t", "<C-space>", "<C-\\><C-n>", { silent = true })

-- Command mappings
local commands = {
  { key = "<ESC>",      cmd = "nohl",      descr = "clear search" },
  { key = "<TAB>",      cmd = "bnext",     descr = "next buffer" },
  { key = "<S-Tab>",    cmd = "bprevious", descr = "previous buffer" },
  { key = "<leader>bd", cmd = "bd",        descr = "delete buffer" },
  { key = "<leader>bn", cmd = "enew",      descr = "buffer new" },
}
for _, command in ipairs(commands) do
  map("n", command.key, "<cmd> " .. command.cmd .. " <CR>", { desc = command.descr, silent = false, noremap = true })
end

-- Window management
local window = { "w", "q", "h", "j", "k", "l" }
for _, win in ipairs(window) do
  map("n", "<C-" .. win .. ">", "<C-w>" .. win, { desc = "window " .. win, silent = false, noremap = true })
end
