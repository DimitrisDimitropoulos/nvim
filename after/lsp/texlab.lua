local exe, rgs
if vim.g.is_windows == true then
  exe = vim.env.HOME .. '\\AppData\\Local\\SumatraPDF\\SumatraPDF.exe'
  rgs = { '-reuse-instance', '%p', '-forward-search', '%f', '%l' }
end
if vim.fn.has 'unix' == 1 then
  exe = 'zathura'
  rgs = { '--synctex-forward', '%l:1:%f', '%p' }
end

return {
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          documentationFormat = { 'plaintext' },
          snippetSupport = true,
        },
      },
    },
  },
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
      -- bibtexFormatter = 'texlab',
      formatterLineLength = 120,
    },
  },
}
