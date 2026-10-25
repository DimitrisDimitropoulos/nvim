# ✨ Custom Neovim config

A personal Neovim config for **Neovim 0.12+**. The focus is a bare-bones UI that
leans on native features, supplemented by a small set of plugins, to deliver a
classic editing experience with a modern touch.

> [!IMPORTANT]
> Requires Neovim 0.12 or newer (built on the native `vim.pack` API).
>
> Most features work without the optional tools below. The exception is
> `mini.pick`, whose file and grep pickers need `ripgrep` or `fd`.
>
> On Windows, prefer `winget` or `scoop`. On Linux, use your distro's package
> manager (`apt`, `dnf`, `pacman`, ...).
>
> - [wl-clipboard](https://github.com/bugaevc/wl-clipboard) for clipboard on Wayland (`wl-copy`/`wl-paste`)
> - [xclip](https://github.com/astrand/xclip) or [xsel](https://github.com/kfish/xsel) for clipboard on X11 (Neovim auto-detects either)
> - [win32yank](https://github.com/equalsraf/win32yank) for clipboard on Windows and WSL
> - [fd](https://github.com/sharkdp/fd) and [ripgrep](https://github.com/BurntSushi/ripgrep) for the `mini.pick` pickers
> - [zathura](https://pwmt.org/projects/zathura/) (Linux) or [SumatraPDF](https://www.sumatrapdfreader.org/free-pdf-reader) (Windows) for PDF preview of LaTeX and Typst documents
> - [pwsh.exe](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pwsh?view=powershell-7.4) if you want to use PowerShell as the shell on Windows
> - [fzf](https://github.com/junegunn/fzf) only if you re-enable the `fzf-lua` fallback

## 🔥 Showcase

![2024-07-25-14:25:58](https://github.com/user-attachments/assets/02033bd9-ac45-428f-b338-61991be638e4)
![2024-07-25-18:50:21](https://github.com/user-attachments/assets/79f0f9dd-fc5c-418a-b9ee-c0005215847c)

## ⚒️ Features

1. Built on the native `vim.pack` plugin manager (Neovim 0.12+) with a custom lazy-loader (`lua/lloader.lua`)
2. Heavy use of native features: `vim.lsp.completion`, `vim.lsp.inline_completion`, and `vim.snippet`
3. Custom JSON snippets in `snippets/`, compatible with VS Code-style snippet formats and loaded through native `vim.snippet`
4. Greek and English spell checking by default, with a custom `vim.ui.select` picker for suggestions
5. Langmap for typing Greek without switching keyboard layouts
6. Language servers for Python (`basedpyright`, `ruff`), Rust (`rust_analyzer`), Typst (`tinymist`), LaTeX (`texlab`), Lua (`lua_ls`), C/C++ (`clangd`), CMake, Julia, Bash, YAML, TOML, and Copilot inline completion
7. Custom statusline and minimal UI for a distraction-free experience
8. Autocommands and a working ftplugin system (`after/ftplugin/`)
9. Custom `efm` language server wiring formatters and linters for various languages
10. LaTeX and Typst PDF preview: `texlab` forward/inverse search with `zathura` on Linux and SumatraPDF on Windows; `tinymist` PDF export for Typst
11. Custom Treesitter queries for highlighting Lua, LaTeX, Typst, and BibTeX
12. `mini.pick` integration for fast file, grep, and git-status pickers
13. Bundled `melange` colorscheme

## 🚀 Installation

Back up your existing config, plugins, data, and cache before installing. Then
move them aside (for example, rename them to `<folder>.bak`), clone this repo
to the config path, and open Neovim. Plugins and Treesitter parsers install
automatically on first launch. Open `:Mason` to install any language servers or
tools you need.

### Linux

```sh
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

Then:

```sh
git clone https://github.com/DimitrisDimitropoulos/nvim.git ~/.config/nvim
nvim
```

### Windows (PowerShell)

```powershell
# required
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak

# optional but recommended
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak
```

Then:

```powershell
git clone https://github.com/DimitrisDimitropoulos/nvim.git $env:LOCALAPPDATA\nvim
nvim
```

### After first launch

Run `:checkhealth` and install any missing dependencies, such as `wl-clipboard`
or `xclip`/`xsel`, `win32yank`, `pwsh.exe`, `rg`, and `fd`.

## 🔌 Plugins

Managed with `vim.pack`:

- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [nvim-mini/mini.splitjoin](https://github.com/nvim-mini/mini.splitjoin)
- [nvim-mini/mini.pick](https://github.com/nvim-mini/mini.pick)
- [nvim-mini/mini.extra](https://github.com/nvim-mini/mini.extra)
- [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)
- [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets)

Included in the repo, not fetched as plugins:

- `melange` colorscheme in `colors/melange.lua` (originally from [savq/melange-nvim](https://github.com/savq/melange-nvim))

Optional, currently disabled:

- [ibhagwan/fzf-lua](https://github.com/ibhagwan/fzf-lua) (fallback picker; uncomment in `lua/plugins.lua` and requires `fzf`)

## 🚗 TODO
