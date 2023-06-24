local keymapp = vim.api.nvim_set_keymap
keymapp("n", "<leader>lf", "<cmd>silent !context %:r.tex; zathura %:r.pdf &<CR>", { desc = "Fompile" })
keymapp("n", "<C-s>", "<cmd>w | :silent !context %:r.tex; zathura -e %:r.pdf &<CR>", { desc = "compile" })
