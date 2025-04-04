vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange) then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      local g = vim.api.nvim_create_augroup('UserCompletion', { clear = true })
      local bufnr = args.buf
      vim.lsp.completion.enable(true, client.id, bufnr, {
        autotrigger = true,
      })
      if #vim.api.nvim_get_autocmds { buffer = bufnr, event = 'InsertCharPre', group = g } ~= 0 then
        return
      end
      vim.api.nvim_create_autocmd('InsertCharPre', {
        buffer = bufnr,
        group = g,
        callback = function()
          if tonumber(vim.fn.pumvisible()) == 1 then
            return
          end
          local triggerchars = vim.tbl_get(client, 'server_capabilities', 'completionProvider', 'triggerCharacters')
            or {}
          if vim.v.char:match '[%w_]' and not vim.list_contains(triggerchars, vim.v.char) then
            vim.schedule(function()
              vim.lsp.completion.get()
            end)
          end
        end,
        desc = 'completion on character which not exist in lsp client triggerCharacters',
      })
      vim.cmd [[
      inoremap <C-j> <C-R>=pumvisible() ? "\<lt>Down>" : "\<lt>C-j>"<CR>
      inoremap <C-k> <C-R>=pumvisible() ? "\<lt>Up>" : "\<lt>C-k>"<CR>
      inoremap <Enter> <C-e><Enter>
      ]]
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
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

    local hover = vim.lsp.buf.hover -- Store the original function in a local variable
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.buf.hover = function()
      return hover { max_height = 20, max_width = 75 }
    end
    local signature_help = vim.lsp.buf.signature_help
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.buf.signature_help = function()
      return signature_help { max_height = 20, max_width = 75 }
    end

    vim.diagnostic.config {
      underline = true,
      virtual_text = { prefix = '\u{23FA}' },
      virtual_lines = { current_line = true },
      signs = {
        text = {
          [vim.diagnostic.severity.HINT] = '\u{23FA}',
          [vim.diagnostic.severity.ERROR] = '\u{23FA}',
          [vim.diagnostic.severity.INFO] = '\u{23FA}',
          [vim.diagnostic.severity.WARN] = '\u{23FA}',
        },
        numhl = {
          [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
          [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
          [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
          [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
        },
      },
      update_in_insert = false,
      float = { source = true },
      jump = { float = true },
    }

    -- works on 0.10.3 but multiple clients is now well supported, therefore use it only on 0.11.X
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local doc_hl = vim.api.nvim_create_augroup('DocumentHighlight' .. tostring(args.buf), { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
        group = doc_hl,
        desc = 'Highlight references under the cursor',
        buffer = args.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
        group = doc_hl,
        desc = 'Clear highlight references',
        buffer = args.buf,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = doc_hl,
        buffer = args.buf,
        callback = function(ev)
          vim.lsp.buf.clear_references()
          if ev.data.client_id == client.id then
            vim.api.nvim_clear_autocmds { group = doc_hl, buffer = args.buf }
          end
        end,
      })
    end

    local map = vim.keymap.set

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

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('AutoFormat', { clear = true }),
        pattern = { '*tex', '*lua', '*py', '*jl', '*json', '*yml', '*rs', '*sh', '*typ' },
        callback = function()
          vim.lsp.buf.format()
        end,
        desc = 'format on save',
      })
    end
  end,
})
