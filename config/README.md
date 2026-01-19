# nvim4python

Full-featured Neovim configuration for Python development, comparable to Visual Studio Code.

## Installation

1. Ensure you have Neovim 0.9+ installed.
2. Copy the files from this repository to `~/.config/nvim`:
   ```bash
   cp -r /path/to/nvim4python/* ~/.config/nvim/
   ```
3. Launch Neovim. Lazy.nvim will automatically install all plugins.

## Main Plugins

- **Dashboard**: Alpha-nvim with greeting "PUPAMUPA".
- **Themes**: 14 dark themes (Catppuccin, TokyoNight, Gruvbox, OneDark, Nightfox, Kanagawa, Dracula, Everforest, Ayu Dark, Material, GitHub Dark, Nord, Rose Pine, Sonokai) with cycling via <leader>tt.
- **Swap Windows**: WinShift for moving windows.
- **Which-key**: Shows keybindings.
- **Surround**: Work with quotes and brackets.
- **LSP**: Pyright for Python, with autocompletion and diagnostics.
- **Treesitter**: Syntax highlighting.
- **Telescope**: File, text, and buffer search.
- **Neo-tree**: File tree explorer.
- **Lualine**: Status bar.
- **Bufferline**: Buffer management.
- **Gitsigns**: Git integration.
- **DAP**: Python debugging.
- **Toggleterm**: Built-in terminal.
- **Comment**: Code commenting.
- **Autopairs**: Automatic brackets.
- **Indent Blankline**: Indentation guides.

## Keybindings

- `<leader>` - space
- `<leader>e` - toggle Neo-tree
- `<leader>ff` - find files (Telescope)
- `<leader>fg` - live grep
- `<leader>fb` - buffers
- `<leader>tt` - cycle themes
- `<C-W>m` - WinShift (move window)
- `gd` - go to definition
- `gr` - go to references
- `K` - hover documentation
- `<leader>ca` - code action
- `<leader>f` - format
- `<F5>` - start debugging
- `<leader>b` - toggle breakpoint

## Theme

Default theme is Catppuccin Mocha. Change in `lua/plugins/init.lua` if needed.

## Troubleshooting

- If plugins fail to install, check internet and restart Neovim.
- For Python, ensure `python` and `pip` are installed.
- For LSP: Mason will install Pyright automatically.
