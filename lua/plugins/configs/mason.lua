require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
      cancel_installation = "<C-c>",
    },
  },
})

local options = {
  ensure_installed = {
    "lua-language-server",
    "selene",
    "stylua",
    "clangd",
    "pyright",
  },
  PATH = "skip",
  max_concurrent_installers = 10,
}
return options
