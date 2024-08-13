local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { 'plaintext' }
capabilities.textDocument.completion.completionItem.snippetSupport = true
local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_ok then
  return
end

local exe, rgs
if vim.g.is_windows == 1 then
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
          modifyLineBreaks = true,
        },
        bibtexFormatter = 'texlab',
        formatterLineLength = 120,
      },
    },
  },
}
