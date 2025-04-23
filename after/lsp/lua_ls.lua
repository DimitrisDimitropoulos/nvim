return {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        maxPreload = 1000,
        preloadFileSize = 1000,
        library = {
          vim.env.VIMRUNTIME,
          '${3rd}/luv/library',
        },
      },
      telemetry = { enable = false },
      hint = { enable = true },
      diagnostics = { globals = { 'vim' } },
      format = { enable = false },
    },
  },
}
