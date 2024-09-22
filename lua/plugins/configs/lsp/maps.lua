local map = vim.keymap.set
local lsp = vim.lsp.buf
local lsp_mappings = {
  -- stylua: ignore start
  { key = "gd", cmd = "definition",              desc = "goto def" },
  { key = "gD", cmd = "declaration",             desc = "goto dec" },
  { key = "gi", cmd = "implementation",          desc = "goto impl" },
  { key = "ln", cmd = "rename",                  desc = "rename" },
  { key = "kk", cmd = "signature_help",          desc = "signature" },
  { key = "gr", cmd = "references",              desc = "references" },
  { key = "gh", cmd = "type_definition",         desc = "type definition" },
  { key = "wa", cmd = "add_workspace_folder",    desc = "add work folder" },
  { key = "wr", cmd = "remove_workspace_folder", desc = "rm work folder" },
  -- stylua: ignore stop
}

local diagno = {
  -- stylua: ignore start
  { key = "<leader>df", cmd = "open_float", descr = "diagnostics float" },
  { key = "<leader>ds", cmd = "show",       descr = "diagnostics show" },
  { key = "<leader>dh", cmd = "hide",       descr = "diagnostics hide" },
  { key = "[d",         cmd = "goto_prev",  descr = "diagnostics prev" },
  { key = "]d",         cmd = "goto_next",  descr = "diagnostics next" },
  -- stylua: ignore stop
}

map("n", "<S-k>", lsp.hover, { desc = "hover" })
map("n", "<leader>qf", lsp.code_action, { desc = "code actions", silent = true })
map("n", "<A-f>", function() lsp.format { async = true } end, { desc = "format code" })
map(
  "n",
  "<space>wl",
  function() print(vim.inspect(lsp.list_workspace_folders())) end,
  { desc = "list workspace folders" }
)
for _, mapping in ipairs(lsp_mappings) do
  map("n", "<leader>" .. mapping.key, lsp[mapping.cmd], { desc = mapping.desc })
end

for _, diag in ipairs(diagno) do
  map("n", diag.key, vim.diagnostic[diag.cmd], { desc = diag.descr })
end
