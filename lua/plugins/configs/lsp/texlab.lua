local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig = require 'lspconfig'

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
vim.api.nvim_create_user_command('TexlabCancel', function() buf_cancel_build() end, { nargs = 0 })

local function dependency_graph()
  local texlab_client = util.get_active_client_by_name(0, 'texlab')
  if texlab_client then
    texlab_client.request('workspace/executeCommand', { command = 'texlab.showDependencyGraph' }, function(err, result)
      if err then error(tostring(err)) end
      vim.notify('The dependency graph has been generated:\n' .. result)
    end, 0)
  end
end
vim.api.nvim_create_user_command('TexlabDependencyGraph', function() dependency_graph() end, { nargs = 0 })

-- BUG: It appears that the LSP is not capable, while it is, I think it has to do with the bufnr, @2024-01-21 00:38:05
-- local function cleanAux(bufnr)
--   bufnr = util.validate_bufnr(bufnr)
--   local texlab_client = util.get_active_client_by_name(bufnr, 'texlab')
--   local params = {
--     command = 'texlab.cleanAuxiliary',
--     arguments = {
--       CleanAuxiliaryParams = { uri = vim.uri_from_bufnr(bufnr) },
--     },
--   }
--   if texlab_client then
--     texlab_client.request('workspace/executeCommand', params, function(err)
--       if err then error(tostring(err)) end
--       vim.notify 'Aux files cleaned'
--     end, 0)
--   end
--   vim.notify 'The capability is not supported by the server'
-- end
-- vim.api.nvim_create_user_command('TexlabCleanAux', function() cleanAux(0) end, { nargs = 0 })

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
          executable = 'zathura',
          args = { '--synctex-forward', '%l:1:%f', '%p' },
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
