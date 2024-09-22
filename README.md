# Custom Neovim config

This config follows the structure of [NvChad](https://github.com/NvChad/NvChad) minimal [config](https://github.com/NvChad/basic-config). This configuration of neovim does not try to replace vscode, but to simply add modern usefull features into vim-neovim, like LSP, IDE completion, statusline, dashboard and other ui. I believe that i have maintained the original spirit of vim and neovim, while adding these features.

## Features of this configuration

1. Based on the [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager for performance, stability, ease of use and features
2. Snippets utilizing both json and lua formats, enabling support for other editors like v.. s.. c..
3. Spell suggest from multiple languages with easy toggle
4. Multiple lsps configured for the best features and performance
5. Custom keybinds neatly organized
6. Telescope extensions for improved performance and features
7. Powerful system with powerful autocommands and a working ftplugin system
8. Scripts to backup and restore your Lazy lock-files
9. Custom efm language server with custom formatters and linters, no plugin dependencies
10. Heavy use of lua
11. Some features for the [ConTeXt](https://wiki.contextgarden.net/Comparison_between_ConTeXt_and_other_typesetting_programs) typesetting system, mainly compilation and preview with [zathura](https://pwmt.org/projects/zathura/)

## Plugins

-   [melange-nvim](https://github.com/savq/melange-nvim)
-   [heirline.nvim](https://github.com/rebelot/heirline.nvim)
-   [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
-   [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
-   [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
    -   [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
    -   [cmp-path](https://github.com/hrsh7th/cmp-path)
    -   [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
    -   [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)
    -   [cmp-nvim-lua](https://github.com/hrsh7th/cmp-nvim-lua)
    -   [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
        -   [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
    -   [nvim-autopairs](https://github.com/windwp/nvim-autopairs)
-   [mason.nvim](https://github.com/williamboman/mason.nvim)
-   [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
-   [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
-   [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
    -   [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
    -   [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)
    -   [telescope-file-browser.nvim](https://github.com/nvim-telescope/telescope-file-browser.nvim)
-   [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
-   [Comment.nvim](https://github.com/numToStr/Comment.nvim)
-   [alpha-nvim](https://github.com/goolord/alpha-nvim)
-   [mini.nvim](https://github.com/echasnovski/mini.nvim)
-   [trouble.nvim](https://github.com/folke/trouble.nvim)
-   [which-key.nvim](https://github.com/folke/which-key.nvim)
-   [nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)
-   [vimtex](https://github.com/lervag/vimtex)
-   [copilot.vim](https://github.com/github/copilot.vim)

## Scripts

The following scripts are based on the features of the lazy.nvim plugin manager. The main usage of those scripts is to restore the plugin state into a stable one. As a result, the plugins can be updated without any fear.

### backup.sh

This Bash script backs up the `lazy-lock.json` file to a backup folder in the user's home directory. It does the following:

1. Gets the backup directory, which is set to `$HOME/.config/nvim/lockfiles`.
2. Creates the backup directory if it doesn't exist.
3. Copies the `lazy-lock.json` file to the backup directory.
4. Names the backup file with the current date and time.
5. Outputs a message indicating that the backup is complete.

### restore.sh

This Bash script restores the `lazy-lock.json` file to the last backup file in the backup folder. It does the following:

1. Gets the backup directory, which is set to `$HOME/.config/nvim/lockfiles`.
2. Checks if the backup directory exists.
3. Gets the last modified file in the backup directory.
4. Prompts the user to confirm before restoring the backup file.
5. If the user confirms, removes the current `lazy-lock.json` file, copies the backup file to the current directory, and renames the backup file to `lazy-lock.json`.
6. Outputs a message indicating that the restore is complete.
7. If there are no backup files found, outputs a message indicating that no backup files were found and suggests using `git reset`.
