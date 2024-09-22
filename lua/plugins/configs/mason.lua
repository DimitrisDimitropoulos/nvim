return {
  ui = {
    icons = {
      package_installed = '\u{2714}',
      package_pending = '\u{26A1}',
      package_uninstalled = '\u{2716}',
    },
  },
  vim.api.nvim_create_user_command('MasonInstallAll', function()
    vim.cmd('MasonInstall ' .. table.concat({
      'lua-language-server',
      'bash-language-server',
      'shellcheck',
      'efm',
      'ruff',
      'prettier',
      'texlab',
    }, ' '))
  end, {}),
  PATH = 'skip',
  max_concurrent_installers = 20,
}
