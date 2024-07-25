# Custom Neovim config

This config begun from the [NvChad](https://github.com/NvChad/NvChad) minimal
[config](https://github.com/NvChad/basic-config), at this point the config is
very different and follows a distinct structure only a few items remain the
same. This configuration of neovim does not try to replace vscode, but to
simply add modern useful features into vim-neovim, like LSP, IDE completion,
statusline, dashboard and other moderate ui features. I believe that i have
maintained the original spirit of vim and neovim, while adding these features.

## Showcase

## Features of this configuration

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

## Installation

Before installing make sure to backup your config, plugins, data and cache.
Then remove it, or better rename it to something like <folder>.bak, for more
context see [here](http://www.lazyvim.org/installation). Then just clone this
repo to the appropriate folder and just open it. The plugins and treesitter
parsers will be installed automatically and then you can open `Mason` and
install manual or with the `MasonInstallAll` command.

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

## Plugins

-   [savq/melange-nvim](https://github.com/savq/melange-nvim)
-   [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
-   [goolord/alpha-nvim](https://github.com/goolord/alpha-nvim)
-   [rebelot/heirline.nvim](https://github.com/rebelot/heirline.nvim)
-   [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
-   [ibhagwan/fzf-lua](https://github.com/ibhagwan/fzf-lua)
-   [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
    -   [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
    -   [nvim-telescope/telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)
-   [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
-   [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
    -   [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
    -   [hrsh7th/cmp-path](https://github.com/hrsh7th/cmp-path)
    -   [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
    -   [hrsh7th/cmp-nvim-lsp-signature-help](https://github.com/hrsh7th/cmp-nvim-lsp-signature-help)
    -   [saadparwaiz1/cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)
    -   [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)
        -   [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
    -   [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)
-   [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
-   [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)
-   [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
-   [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
-   [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)
-   [zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua)
-   [echasnovski/mini.splitjoin](https://github.com/echasnovski/mini.splitjoin)
-   [folke/which-key.nvim](https://github.com/folke/which-key.nvim)
-   [NvChad/nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)

## Scripts

The following scripts are based on the features of the lazy.nvim plugin
manager. The main usage of those scripts is to restore the plugin state into a
stable one. As a result, the plugins can be updated without any fear.

### backup.sh

This Bash script backs up the `lazy-lock.json` file to a backup folder in the
user's home directory. It does the following:

1. Gets the backup directory, which is set to `$HOME/.config/nvim/lockfiles`.
2. Creates the backup directory if it doesn't exist.
3. Copies the `lazy-lock.json` file to the backup directory.
4. Names the backup file with the current date and time.
5. Outputs a message indicating that the backup is complete.

### restore.sh

This Bash script restores the `lazy-lock.json` file to the last backup file in
the backup folder. It does the following:

1. Gets the backup directory, which is set to `$HOME/.config/nvim/lockfiles`.
2. Checks if the backup directory exists.
3. Gets the last modified file in the backup directory.
4. Prompts the user to confirm before restoring the backup file.
5. If the user confirms, removes the current `lazy-lock.json` file, copies the
   backup file to the current directory, and renames the backup file to
   `lazy-lock.json`.
6. Outputs a message indicating that the restore is complete.
7. If there are no backup files found, outputs a message indicating that no
   backup files were found and suggests using `git reset`.

### backup.ps1

This script achieves the same task with the `sh` one in `PowerShell`. However,
the name of the backup file is intentionally different. I recommend to install
the `pwsh.exe` if you are using windows. The script does the following:

1. The script sets the `nvim_dir` variable to the path of the `nvim` directory
   in the user's AppData\Local directory.

2. It checks if the `nvim` directory exists. If it doesn't, the script throws
   an error.

3. The script sets the `lockfiles_dir` variable to the path of the `lockfiles`
   directory inside the `nvim` directory.

4. It checks if the `lockfiles` directory exists. If it doesn't, the script
   throws an error.

5. The script sets the `initial_file` variable to the path of the
   `lazy-lock.json` file inside the `nvim` directory.

6. It checks if the `lazy-lock.json` file exists. If it doesn't, the script
   throws an error.

7. The script checks if `lazy-lock.json` is a file and not a directory. If it's
   not a file, the script throws an error.

8. If `lazy-lock.json` is a file, the script copies it to the `lockfiles`
   directory.

9. The script renames the copied `lazy-lock.json` file in the `lockfiles`
   directory to `lazy-lock-<current-date-and-time>.json`. The date and time
   format is `yyyy-MM-dd-HH-mm-ss`.

10. Finally, the script prints a message to the console indicating the new name
    of the copied and renamed file, and specifies the date format used in the
    new file name.

### restore.ps1

This `PowerShell` script is designed to restore the `lazy-lock.json` file from
the most recent backup in the `lockfiles` directory. It prompts the user for
confirmation before performing the restore operation. It proceeds as follows:

1. The script sets the `backup_dir` variable to the path of the `lockfiles`
   directory in the user's AppData\Local\nvim directory.

2. It checks if the `lockfiles` directory exists. If it doesn't, the script
   throws an error.

3. The script sets the `nvim_dir` variable to the path of the `nvim` directory
   in the user's AppData\Local directory.

4. It checks if the `nvim` directory exists. If it doesn't, the script throws
   an error.

5. The script gets the last modified file in the `lockfiles` directory and
   prints its name.

6. It checks if the last modified file exists and is not a directory. If it's
   not a file, the script throws an error.

7. The script prompts the user to confirm if they want to restore the last
   modified file to the `lazy-lock.json` file.

8. If the user confirms, the script sets the `lazy_lock_file` variable to the
   path of the `lazy-lock.json` file in the `nvim` directory.

9. It checks if the `lazy-lock.json` file exists. If it doesn't, the script
   throws an error.

10. The script copies the last modified file to the `nvim` directory.

11. It deletes the `lazy-lock.json` file.

12. The script renames the copied file to `lazy-lock.json`.

13. Finally, the script prints a "Done" message to the console. If the user
    didn't confirm the restore, the script prints an "Aborted" message.

## TODO
