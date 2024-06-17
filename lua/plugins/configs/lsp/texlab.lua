local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_ok then return end

local util = require 'lspconfig.util'

local function buf_cancel_build()
  local texlab_client = util.get_active_client_by_name(0, 'texlab')
  if texlab_client then
    texlab_client.request('workspace/executeCommand', { command = 'texlab.cancelBuild' }, function(err)
      if err then error(tostring(err)) end
      print 'Build cancelled'
    end, 0)
  end
end
vim.api.nvim_create_user_command(
  'TexlabCancel',
  function() buf_cancel_build() end,
  { nargs = 0, desc = 'Cancel build, includes the onSave' }
)

local function dependency_graph()
  local texlab_client = util.get_active_client_by_name(0, 'texlab')
  if texlab_client then
    texlab_client.request('workspace/executeCommand', { command = 'texlab.showDependencyGraph' }, function(err, result)
      if err then error(tostring(err)) end
      vim.notify('The dependency graph has been generated:\n' .. result)
    end, 0)
  end
end
vim.api.nvim_create_user_command(
  'TexlabDependencyGraph',
  function() dependency_graph() end,
  { nargs = 0, desc = 'Generate dependency graph in DOT' }
)

local function cleanArtifacts(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local texlab_client = util.get_active_client_by_name(bufnr, 'texlab')
  if not texlab_client then
    vim.notify 'Texlab client not found'
    return
  end
  local params = {
    command = 'texlab.cleanArtifacts',
    arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
  }
  texlab_client.request('workspace/executeCommand', params, function(err, _, _)
    if err then
      error(tostring(err))
    else
      vim.notify 'Artifacts cleaned successfully'
    end
  end, 0)
end
vim.api.nvim_create_user_command(
  'TexlabCleanArtifacts',
  function() cleanArtifacts(0) end,
  { nargs = 0, desc = 'Clean artifacts, latexmk -C' }
)

local function cleanAuxliary(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local texlab_client = util.get_active_client_by_name(bufnr, 'texlab')
  if not texlab_client then
    vim.notify 'Texlab client not found'
    return
  end
  local params = {
    command = 'texlab.cleanAuxiliary',
    arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
  }
  texlab_client.request('workspace/executeCommand', params, function(err, _, _)
    if err then
      error(tostring(err))
    else
      vim.notify 'Auxiliary cleaned successfully'
    end
  end, 0)
end
vim.api.nvim_create_user_command(
  'TexlabCleanAuxiliary',
  function() cleanAuxliary(0) end,
  { nargs = 0, desc = 'Clean auxiliary, latexmk -c' }
)

local exe, rgs
if vim.fn.has 'win32' == 1 then
  exe = vim.env.HOME .. '\\AppData\\Local\\SumatraPDF\\SumatraPDF.exe'
  rgs = { '-reuse-instance', '%p', '-forward-search', '%f', '%l' }
end
if vim.fn.has 'unix' == 1 then
  exe = 'zathura'
  rgs = { '--synctex-forward', '%l:1:%f', '%p' }
end
return {
  -- NOTE: with the following config it can replace null-ls and vimtex, @2023-08-11 15:29:27
  lspconfig.texlab.setup {
    capabilities = capabilities,
    settings = {
      texlab = {
        experimental = {
          verbatimEnvironments = { 'minted', 'lstlisting' },
          mathEnvironments = { 'cases', 'equation', 'equation*', 'align', 'align*' },
          enumEnvironments = { 'enumerate', 'itemize', 'description' },
          citationCommands = { 'textcite', 'cite', 'parencite', 'supercite', 'autocite' },
        },
        build = {
          auxDirectory = 'build',
          logDirectory = 'build',
          pdfDirectory = 'build',
          onSave = true,
          args = {
            '-pdf',
            '-lualatex',
            '-interaction=nonstopmode',
            '-aux-directory=build',
            '-output-directory=build',
            '-synctex=1',
            '%f',
          },
        },
        forwardSearch = {
          -- executable = 'zathura',
          -- args = { '--synctex-forward', '%l:1:%f', '%p' },
          executable = exe,
          args = rgs,
        },
        chktex = {
          onOpenAndSave = true,
          onEdit = true,
        },
        diagnosticsDelay = 200,
        latexFormatter = 'latexindent',
        latexindent = {
          ['local'] = nil, -- local is a reserved keyword
          modifyLineBreaks = false,
        },
        bibtexFormatter = 'texlab',
        formatterLineLength = 120,
      },
    },
  },
}
