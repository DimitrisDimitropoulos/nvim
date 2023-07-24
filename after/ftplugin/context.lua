local map = vim.api.nvim_set_keymap
map("n", "<leader>lf", "<cmd>silent !context %:r.tex; zathura %:r.pdf & <CR>", { desc = "Fompile" })
map("n", "<C-s>", "<cmd>w <CR>| :silent !context %:r.tex; zathura -e %:r.pdf & <CR>", { desc = "Compile" })
