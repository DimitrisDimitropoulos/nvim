-- keymap wrapper
local map = vim.keymap.set

-- augroup wrapper
local function augroup(name) return vim.api.nvim_create_augroup(name, { clear = true }) end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup "YankHighlight",
  callback = function()
    vim.highlight.on_yank {
      timeout = 250,
      higroup = "Visual",
    }
  end,
  desc = "highlight on yank",
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup "last_loc",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
  desc = "last loc",
})

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

vim.api.nvim_create_autocmd("FileType", {
  group = augroup "spell",
  pattern = {
    "gitcommit",
    "markdown",
    "tex",
    "text",
  },
  callback = function() vim.opt_local.spell = true end,
  desc = "spell on specific filetypes",
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup "AutoFormat",
  pattern = {
    "*tex",
    "*lua",
    "*py",
    "*jl",
    "*json",
    "*yaml",
    "*rs",
    "*sh",
  },
  -- callback = function() vim.lsp.buf.format { async = true } end,
  callback = function() vim.lsp.buf.format() end,
  desc = "format on save",
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup "MakeExecutable",
  pattern = {
    "*.sh",
    "*.bash",
    "*.zsh",
  },
  callback = function() vim.fn.system("chmod +x " .. vim.fn.expand "%") end,
  desc = "make executable",
})

-- -- check for windows and make maps
-- vim.api.nvim_create_autocmd("BufEnter", {
--   group = augroup "MakeMaps",
--   pattern = "*",
--   callback = function()
--     if #vim.api.nvim_tabpage_list_wins(0) > 1 then
--       local window = { "w", "q", "h", "j", "k", "l" }
--       for _, win in ipairs(window) do
--         map(
--           n,
--           "<C-" .. win .. ">",
--           "<C-w>" .. win,
--           { desc = "window " .. win },
--           opts
--         )
--       end
--     end
--   end,
--   desc = "make maps",
-- })

local diagnostics_active = true
map("n", "<leader>hd", function()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end, {
  desc = "toggle diagnostics",
  silent = false,
  noremap = true,
})

local function toggle_spell_check() vim.opt.spell = not (vim.opt.spell:get()) end
map("n", "<A-z>", toggle_spell_check, { desc = "toggle spell check", silent = false, noremap = true })
