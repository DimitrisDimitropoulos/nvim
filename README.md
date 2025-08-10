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
> -   [xclip](https://github.com/astrand/xclip) for clipboard on X11
> -   [fd](https://github.com/sharkdp/fd) [ripgrep](https://github.com/BurntSushi/ripgrep) [fzf](https://github.com/junegunn/fzf) for the picker either fzf-lua or telescope
> -   [zathura](https://pwmt.org/projects/zathura/) or [SumatraPDF](https://www.sumatrapdfreader.org/free-pdf-reader) for pdf functionality when previewing LaTeX documents
> -   [pwsh.exe](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pwsh?view=powershell-7.4) if you want to use it as the shell for windows usage

## 🔥 Showcase

![2024-07-25-14:25:58](https://github.com/user-attachments/assets/02033bd9-ac45-428f-b338-61991be638e4)
![2024-07-25-18:50:21](https://github.com/user-attachments/assets/79f0f9dd-fc5c-418a-b9ee-c0005215847c)

## ⚒️ Features of this configuration

1. Based on the [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager
2. Snippets utilizing both json and lua formats, enabling support for other
   editors like vscode
3. Default spell for greek and english
4. Langmap for greek input
5. Language Servers for multiple languages
6. Custom keybinds neatly organized per use-case
7. Telescope extensions for improved performance
8. Powerful system with autocommands and a working ftplugin system
9. Scripts to backup and restore your Lazy lock-files, in `bash` and `pwsh`
10. Custom efm language server with formatters and linters, no plugin
    dependencies
11. Heavy use of lua wherever feasible
12. LaTeX preview based on `texlab` with `zathura` on linux and
    [SumatraPDF](https://www.sumatrapdfreader.org/free-pdf-reader) on windows
13. Custom treesitter queries for highlighting `lua` and `LaTeX`
14. Powerful native snippets framework, with framework agnostic autocompletion

## 🚀 Installation

Before installing make sure to backup your config, plugins, data and cache.
Then remove it, or better rename it to something like <folder>.bak, for more
context see [here](http://www.lazyvim.org/installation). Then just clone this
repo to the appropriate folder and just open it. The plugins and treesitter
parsers will be installed automatically and then you can open `Mason` and
install any program manually.

For more detailed instructions based on the LazyVim:

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

```
# required
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak

# optional but recommended
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak
```

Then

```
git clone https://github.com/DimitrisDimitropoulos/nvim.git $env:LOCALAPPDATA\nvim
nvim
```

After launching all plugins make sure to run a `:checkhealth` command and install all the dependencies you may lack like `xclip`, `pwsh.exe`, `rg`, `fd` and `fzf`

## 🔌 Plugins

- [savq/melange-nvim](https://github.com/savq/melange-nvim)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [saghen/blink.cmp](https://github.com/saghen/blink.cmp)
- [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua)
- [echasnovski/mini.splitjoin](https://github.com/echasnovski/mini.splitjoin)
- [folke/which-key.nvim](https://github.com/folke/which-key.nvim)\* (disabled)
- [ibhagwan/fzf-lua](https://github.com/ibhagwan/fzf-lua)
- [nvimdev/indentmini.nvim](https://github.com/nvimdev/indentmini.nvim)\* (disabled)
- [brenoprata10/nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors)\* (disabled)

## 🚗 TODO
