-- keymap wrapper
local keymapp = vim.keymap.set
local opts = {
  noremap = true,
  silent = false,
}
local n = "n"

-- augroup wrapper
local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup "YankHighlight",
  command = "lua vim.highlight.on_yank()",
  desc = "highlight on yank",
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup "last_loc",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "last loc",
})

-- close some filetypes with <q> From LazyVim
vim.api.nvim_create_autocmd("FileType", {
  group = augroup "close_with_q",
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "close with q",
})

-- Enable filetype specific keymaps
vim.api.nvim_create_autocmd("FileType", {
  group = augroup "TroubleOpen",
  pattern = {
    "lua",
    "cpp",
    "c",
    "python",
    "julia",
  },
  callback = function()
    vim.keymap.set("n", "<leader>tr", "<cmd> TroubleToggle <CR>")
  end,
  desc = "trouble",
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup "wrap_spell",
  pattern = {
    "gitcommit",
    "markdown",
    "tex",
    "text",
  },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  desc = "wrap and spell",
})

-- Autoformatting on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup "AutoFormat",
  pattern = {
    "*tex",
    "*lua",
    "*py",
    "*jl",
    "*json",
    "*yaml",
  },
  callback = function()
    vim.lsp.buf.format { async = true }
  end,
  desc = "format on save",
})

-- Make scripts executable
vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup "MakeExecutable",
  pattern = {
    "*.sh",
    "*.bash",
    "*.zsh",
  },
  callback = function()
    vim.fn.system("chmod +x " .. vim.fn.expand "%")
  end,
  desc = "make executable",
})

-- toggle diagnostics
local diagnostics_active = true
keymapp(n, "<leader>hd", function()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end, {
  desc = "toggle diagnostics",
}, opts)

-- Toggle spell check
local function toggle_spell_check()
  vim.opt.spell = not (vim.opt.spell:get())
end
keymapp(n, "<A-z>", toggle_spell_check, { desc = "toggle spell check" }, opts)
