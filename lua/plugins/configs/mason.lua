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
