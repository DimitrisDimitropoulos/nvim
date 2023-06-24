-- vim.keymap.set()
local keymapp = vim.keymap.set
local opts = { noremap = true, silent = false }
-- keymapp("n", "<leader>tc", "<cmd> AerialToggle<CR>", opts)
keymapp("n", "<leader>tr", "<cmd> TroubleToggle <CR>", { desc = "diagnotics" }, opts)
