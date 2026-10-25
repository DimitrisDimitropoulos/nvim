vim.api.nvim_create_user_command('GetTypstLabels', function()
  require('utils').gen_loclist(require('utils').get_entries('((label) @label)', 'typst'), 'Typst Labels')
end, { nargs = 0, desc = 'Generate a location list with Typst labels' })

vim.keymap.set('n', 'gO', function()
  require('utils').gen_loclist(
    require('utils').get_entries('((section (heading (text) @text)))', 'typst'),
    'Typst Headings'
  )
end, { silent = true, noremap = true, desc = 'User: show LaTeX TOC' })

local exe, rgs
if vim.fn.has 'win32' == 1 then
  exe = vim.fs.joinpath(vim.env.HOME, 'AppData', 'Local', 'SumatraPDF', 'SumatraPDF.exe')
  rgs = { '-reuse-instance' }
end
if vim.fn.has 'unix' == 1 then
  exe = 'zathura'
  rgs = {}
end

local function open_pdf(filepath)
  if exe and vim.fn.executable(exe) == 1 then
    vim.ui.open(filepath, { cmd = vim.list_extend({ exe }, rgs) })
  else
    vim.ui.open(filepath)
  end
end

local function tinymist_export_and_open()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { bufnr = bufnr, name = 'tinymist' }
  local client = clients[1]
  if not client then
    return vim.notify('Tinymist client not found', vim.log.levels.ERROR)
  end
  ---@type lsp.Handler
  local function handler(err, res)
    if err then
      return vim.notify('Export Error: ' .. err.message, vim.log.levels.ERROR)
    end
    -- Expecting res to be a table: { path = "/path/to/file.pdf" }
    if res and res.path then
      local filepath = res.path
      vim.notify('Opening PDF: ' .. filepath, vim.log.levels.INFO)
      open_pdf(filepath)
    else
      vim.notify('Export successful, but no file path returned.', vim.log.levels.WARN)
    end
  end
  -- Execute the workspace command
  client:exec_cmd({
    title = 'Export and Open PDF',
    command = 'tinymist.exportPdf',
    arguments = { vim.api.nvim_buf_get_name(bufnr) },
  }, { bufnr = bufnr }, handler)
end

vim.api.nvim_create_user_command('TinymistOpenPdf', tinymist_export_and_open, {
  desc = 'Export Typst to PDF via Tinymist and open the result',
})
