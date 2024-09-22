vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(args)
    if false then
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        vim.lsp.inlay_hint.enable()
      end
    end
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
    vim.lsp.handlers['textDocument/signatureHelp'] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
    local lsp_utils = { 'diagnostics', 'maps', 'format' }
    for _, lsp in ipairs(lsp_utils) do
      require('lsp.' .. lsp)
    end
  end,
})