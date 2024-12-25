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

    if vim.version().minor < 11 then
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = vim.g.border_style })
      vim.lsp.handlers['textDocument/signatureHelp'] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = vim.g.border_style })
    else
      local hover = vim.lsp.buf.hover -- Store the original function in a local variable
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.buf.hover = function()
        return hover { border = vim.g.border_style } -- Use the original function
      end
      local signature_help = vim.lsp.buf.signature_help
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.buf.signature_help = function()
        return signature_help { border = vim.g.border_style }
      end
    end

    vim.diagnostic.config {
      underline = true,
      virtual_text = { prefix = '\u{1F5D9}' },
      signs = {
        text = {
          [vim.diagnostic.severity.HINT] = '\u{25A1}',
          [vim.diagnostic.severity.ERROR] = '\u{25A0}',
          [vim.diagnostic.severity.INFO] = '\u{25CF}',
          [vim.diagnostic.severity.WARN] = '\u{25B3}',
        },
      },
      update_in_insert = false,
      float = { source = 'always', border = vim.g.border_style },
      jump = { float = true },
    }

    local map = vim.keymap.set

    if vim.version().minor < 11 then
      map('n', 'grr', vim.lsp.buf.references, { desc = 'lsp references' })
      map('n', 'gri', vim.lsp.buf.implementation, { desc = 'lsp implementation' })
      map('n', 'grn', vim.lsp.buf.rename, { desc = 'lsp rename' })
      map('n', 'gra', vim.lsp.buf.code_action, { desc = 'lsp code actions', silent = true })
      map('i', '<C-s>', vim.lsp.buf.signature_help, { desc = 'lsp signature help' })
    end
    map('n', '<leader>lh', function()
      if vim.lsp.inlay_hint.is_enabled() then
        vim.lsp.inlay_hint.enable(false)
      else
        vim.lsp.inlay_hint.enable(true)
      end
    end, { desc = 'lsp toggle inlay hints' })
    map('n', '<leader>lf', function()
      vim.lsp.buf.format { async = true }
      vim.notify('The buffer has been formatted', vim.log.levels.INFO)
    end, { desc = 'lsp async format' })

    map('n', 'grd', vim.lsp.buf.declaration, { desc = 'lsp declaration' })
    map('n', 'grt', vim.lsp.buf.type_definition, { desc = 'lsp type definition' })

    map('n', '<leader>ds', vim.diagnostic.show, { desc = 'diagnostics show' })
    map('n', '<leader>dh', vim.diagnostic.hide, { desc = 'diagnostics hide' })
    map('n', '<leader>dq', vim.diagnostic.setqflist, { desc = 'diagnostics setqflist' })
    map('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'diagnostics setloclist' })

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('AutoFormat', { clear = true }),
      pattern = { '*tex', '*lua', '*py', '*jl', '*json', '*yml', '*rs', '*sh' },
      callback = function()
        vim.lsp.buf.format()
      end,
      desc = 'format on save',
    })
  end,
})
