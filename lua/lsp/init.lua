vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(args)
    if false then
      vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
    end

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      local inlay_hints_group = vim.api.nvim_create_augroup('InlayHintAuto', { clear = false })
      vim.defer_fn(function()
        local mode = vim.api.nvim_get_mode().mode
        vim.lsp.inlay_hint.enable(mode == 'n' or mode == 'v', { bufnr = args.buf })
      end, 500)
      vim.api.nvim_create_autocmd('InsertEnter', {
        group = inlay_hints_group,
        desc = 'Enable inlay hints',
        buffer = args.buf,
        callback = function()
          vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
        end,
      })
      vim.api.nvim_create_autocmd('InsertLeave', {
        group = inlay_hints_group,
        desc = 'Disable inlay hints',
        buffer = args.buf,
        callback = function()
          vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end,
      })
    end

    -- drop this after 0.11
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = vim.g.border_style })
    vim.lsp.handlers['textDocument/signatureHelp'] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = vim.g.border_style })
    local hover = vim.lsp.buf.hover -- Store the original function in a local variable
    vim.lsp.buf.hover = function()
      return hover { border = vim.g.border_style } -- Use the original function
    end
    local signature_help = vim.lsp.buf.signature_help
    vim.lsp.buf.signature_help = function()
      return signature_help { border = vim.g.border_style }
    end

    for _, lsp in ipairs { 'diagnostics', 'maps', 'format' } do
      require('lsp.' .. lsp)
    end
  end,
})
