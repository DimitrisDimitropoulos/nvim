local ensure_installed = {
  'lua-language-server',
  'bash-language-server',
  'shellcheck',
  'efm',
  'ruff',
  'prettier',
  'texlab',
}

require('mason').setup {
  ui = {
    icons = { package_installed = '✓', package_pending = '➜', package_uninstalled = '✗' },
    keymaps = {
      toggle_server_expand = '<CR>',
      install_server = 'i',
      update_server = 'u',
      check_server_version = 'c',
      update_all_servers = 'U',
      check_outdated_servers = 'C',
      uninstall_server = 'X',
      cancel_installation = '<C-c>',
    },
  },
  vim.api.nvim_create_user_command(
    'MasonInstallAll',
    function() vim.cmd('MasonInstall ' .. table.concat(ensure_installed, ' ')) end,
    {}
  ),
  PATH = 'skip',
  max_concurrent_installers = 20,
}
