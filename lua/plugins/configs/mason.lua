return {
  ui = { icons = { package_installed = '', package_pending = '', package_uninstalled = '' } },
  vim.api.nvim_create_user_command('MasonInstallAll', function()
    vim.cmd(
      'MasonInstall ' .. table.concat({ 'lua-language-server', 'stylua', 'efm', 'ruff', 'prettier', 'texlab' }, ' ')
    )
  end, {}),
  PATH = 'skip',
  max_concurrent_installers = 20,
}
