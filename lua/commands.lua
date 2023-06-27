local keymapp = vim.keymap.set
local opts = {
  noremap = true,
  silent = false,
}
local n = "n"

-- Highlight on yank
local yankGrp = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  command = "lua vim.highlight.on_yank()",
  group = yankGrp,
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
