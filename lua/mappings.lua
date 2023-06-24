local keymapp = vim.keymap.set
local opts = { noremap = true, silent = false }
local lsp = vim.lsp.buf
local n = "n"

-- general mappings
keymapp("n", "<C-s>", "<cmd> w <CR>")
keymapp(n, "<ESC>", "<cmd> nohl <CR>", { desc = "clear search" }, opts)

-- comment.nvim
keymapp("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end)

keymapp("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")

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

-- bufferline alternative
keymapp(n, "<TAB>", "<cmd> bnext<CR>", { desc = "next buffer" }, opts)
keymapp(n, "<S-Tab>", "<cmd> bprevious<CR>", { desc = "previous buffer" }, opts)
keymapp(n, "<leader>bd", "<cmd> bd<CR>", { desc = "delete buffer" }, opts)
keymapp(n, "<leader>bn", "<cmd> enew <CR>", { desc = "buffer new" }, opts)

-- Lsp mappings
keymapp(n, "<A-f>", lsp.format, { desc = "format code" }, opts)
keymapp(n, "<leader>gd", lsp.definition, { desc = "go to definition" }, opts)
keymapp(n, "<leader>gD", lsp.declaration, { desc = "go to declaration" }, opts)
keymapp(n, "<leader>gi", lsp.implementation, { desc = "go to implementation" }, opts)
keymapp(n, "<leader>ln", lsp.rename, { desc = "rename" }, opts)
keymapp(n, "<S-k>", lsp.hover, { desc = "hover" }, opts)
keymapp(n, "<leader>kk", lsp.signature_help, { desc = "signature" }, opts)
keymapp(n, "<leader>gr", lsp.references, { desc = "references" }, opts)
keymapp(n, "<leader>gh", lsp.type_definition, { desc = "type definition" }, opts)
keymapp(n, "<leader>qf", lsp.code_action, { desc = "code actions" }, { silent = true })

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

-- Toggle spell check
local function toggle_spell_check()
  vim.opt.spell = not (vim.opt.spell:get())
end
keymapp(n, "<A-z>", toggle_spell_check, { desc = "toggle spell check" }, opts)

keymapp(n, "<leader>ff", "<cmd> Telescope find_files <CR>")
keymapp(
  n,
  "<leader>fa",
  "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
  { desc = "find all" },
  opts
)
keymapp(n, "<leader>lg", "<cmd> Telescope live_grep <CR>", { desc = "live grep" }, opts)
keymapp(n, "<leader>fs", "<cmd> Telescope grep_string <CR>", { desc = "" }, opts)
keymapp(n, "<leader>fb", "<cmd> Telescope buffers <CR>", { desc = "find buffers" }, opts)
keymapp(n, "<leader>fh", "<cmd> Telescope help_tags <CR>", { desc = "find help tags" }, opts)
-- keymapp(n, "<leader>fm",  "<cmd> Telescope marks <CR>", { desc = "find marks" }, opts)
keymapp(n, "<leader>fr", "<cmd> Telescope oldfiles <CR>", { desc = "find old files" }, opts)
keymapp(n, "<leader>fk", "<cmd> Telescope keymaps <CR>", { desc = "find keymaps" }, opts)
keymapp(n, "<leader>re", "<cmd> Telescope registers <CR>", { desc = "find registers" }, opts)
keymapp(n, "<leader>", "<cmd> Telescope registers <CR>", { desc = "find registers" }, opts)
keymapp(n, "<leader>dd", "<cmd> Telescope diagnostics <CR>", { desc = "find diagnostics" }, opts)
keymapp(n, "<leader>ch", "<cmd> Telescope command_history <CR>", { desc = "find command history" }, opts)
keymapp(
  n,
  "<leader>ts",
  "<cmd> Telescope treesitter default_text=function initial_mode=normal <CR>",
  { desc = "find treesitter" },
  opts
)
keymapp(n, "<leader>ld", "<cmd> Telescope lsp_definitions <CR>", { desc = "find lsp definitions" }, opts)
keymapp(n, "<leader>sp", "<cmd> Telescope spell_suggest <CR>", { desc = "find spell suggestions" }, opts)
keymapp(n, "<leader>fz", "<cmd> Telescope current_buffer_fuzzy_find <CR>", { desc = "find current buffer fuzzy" }, opts)
