# ✨ Custom Neovim config

This is a custom nvim config. The main focus is a bare bones ui, while
leveraging native features with a few plugins, in order to achieve classic
editing experience with a modern touch.

> [!IMPORTANT]
> It is suggested to have some dependencies when using this config for the best
> experience. Most of the functionality will be kept if they are not installed,
> except for fzf-lua, which requires `fzf` to work. For windows prefer safe
> installation methods like `winget` or `scoop`. On linux use your distro's
> package manager like `apt` or `dnf`
>
> -   [xsel](https://github.com/kfish/xsel) for clipboard on X11
> -   [fd](https://github.com/sharkdp/fd) [ripgrep](https://github.com/BurntSushi/ripgrep) [fzf](https://github.com/junegunn/fzf) for the `fzf-lua` picker
> -   [zathura](https://pwmt.org/projects/zathura/) or [SumatraPDF](https://www.sumatrapdfreader.org/free-pdf-reader) for pdf functionality when previewing LaTeX documents
> -   [pwsh.exe](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pwsh?view=powershell-7.4) if you want to use it as the shell for windows usage

## 🔥 Showcase

![2024-07-25-14:25:58](https://github.com/user-attachments/assets/02033bd9-ac45-428f-b338-61991be638e4)
![2024-07-25-18:50:21](https://github.com/user-attachments/assets/79f0f9dd-fc5c-418a-b9ee-c0005215847c)

## ⚒️ Features of this configuration

1. Based on native `vim.pack` (Neovim 0.12+)
2. Heavy use of native Neovim features, including `vim.lsp.completion`, `vim.lsp.inline_completion`, and `vim.snippet`
3. Custom snippet system in json `snippets/`, enabling compatibility with other editors like VS Code and leveraging native `vim.snippet`
4. Default spell for greek and english with custom `vim.ui.select` picker
5. Langmap for greek input
6. Language Servers for multiple languages (Python, Rust, Typst, Lua, etc.)
7. Neovide support with dynamic font resizing and optimized animations
8. Custom statusline and minimal UI for a distraction-free experience
9. Powerful system with autocomcommands and a working ftplugin system
10. Custom efm language server with formatters and linters for various languages
11. LaTeX preview based on `texlab` with `zathura` on linux and [SumatraPDF](https://www.sumatrapdfreader.org/free-pdf-reader) on windows
12. Custom treesitter queries for highlighting `lua` and `LaTeX`
13. Fzf-lua integration for fast and efficient searching and picking
14. Lazy-loading system via custom `lloader.lua` using `vim.pack` native API

## 🚀 Installation

Before installing make sure to backup your config, plugins, data and cache.
Then remove it, or better rename it to something like `<folder>.bak`. Then just clone this
repo to the appropriate folder and just open it. The plugins and treesitter
parsers will be installed automatically and then you can open `Mason` and
install any program manually.

On Linux

```sh
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

Then

```sh
git clone https://github.com/DimitrisDimitropoulos/nvim.git ~/.config/nvim
nvim
```

On Windows with PowerShell

```powershell
# required
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak

# optional but recommended
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak
```

Then

```powershell
git clone https://github.com/DimitrisDimitropoulos/nvim.git $env:LOCALAPPDATA\nvim
nvim
```

After launching all plugins make sure to run a `:checkhealth` command and install all the dependencies you may lack like `xsel`, `pwsh.exe`, `rg`, `fd` and `fzf`

## 🔌 Plugins

- [savq/melange-nvim](https://github.com/savq/melange-nvim)
- [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [echasnovski/mini.splitjoin](https://github.com/nvim-mini/mini.splitjoin)
- [ibhagwan/fzf-lua](https://github.com/ibhagwan/fzf-lua)
- [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)

## 🚗 TODO
