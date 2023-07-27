# Custom Neovim config

It follows the structure of NvChad

## Features of this configuration

1. Snippets with VsCode like syntax ready to be added
2. Spell suggest from multiple languages with easy toggle
3. Multiple lsp set up and ready to go
4. Custom keybinds neatly organized
5. Telescope extensions for improved performance
6. Powerful system with powerful autocommands and a working ftplugin
7. Scripts to backup and restore your Lazy lock-files

## Keybinds

### Telescope keybinds

| Key | Description          |
| --- | -------------------- |
| ff  | files                |
| f;  | commands             |
| lg  | live grep            |
| fs  | string mark          |
| fb  | buffers              |
| fh  | help tags            |
| fm  | marks                |
| fr  | old files            |
| fk  | keymaps              |
| re  | registers            |
| fd  | diagnostics          |
| ch  | command history      |
| ld  | lsp definitions      |
| sp  | spell suggestions    |
| fz  | current buffer fuzzy |
| ts  | treesitter function  |
| fa  | hidden               |

### Other keybinds

| Key   | Command    | Description       |
| ----- | ---------- | ----------------- |
| ESC   | nohl       | clear search      |
| TAB   | bnext      | next buffer       |
| S-Tab | bprevious  | previous buffer   |
| bd    | bd         | delete buffer     |
| bn    | enew       | buffer new        |
| df    | open_float | diagnostics float |
| [d    | goto_prev  | diagnostics prev  |
| ]d    | goto_next  | diagnostics next  |

## TODO

[] Wait for a solution to null-ls archiving
