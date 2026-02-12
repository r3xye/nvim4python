# nvim4python

Full-featured Neovim configuration for Python and C/C++ development, comparable to Visual Studio Code.

## Installation

1. Ensure you have Neovim 0.9+ installed.
2. Copy the files from this repository to `~/.config/nvim`:
   ```bash
   cp -r /path/to/nvim4python/* ~/.config/nvim/
   ```
3. Launch Neovim. Lazy.nvim will automatically install all plugins.

## Main Plugins

- **Dashboard**: Alpha-nvim with greeting "PUPAMUPA".
- **Themes**: 16 dark themes (Catppuccin, TokyoNight, Gruvbox, OneDark, Nightfox, Kanagawa, Dracula, Everforest, Gruvbox Material, Ayu Dark, Material, GitHub Dark, Nord, Rose Pine, Sonokai, Nightfly) with cycling via <leader>tt.
- **Swap Windows**: WinShift for moving windows.
- **Which-key**: Shows keybindings.
- **Surround**: Work with quotes and brackets.
- **LSP**: Pyright (Python) and clangd (C/C++) with autocompletion and diagnostics.
- **Treesitter**: Syntax highlighting.
- **Telescope**: File, text, and buffer search.
- **Neo-tree**: File tree explorer.
- **Lualine**: Status bar.
- **Bufferline**: Buffer management.
- **Gitsigns**: Git integration.
- **DAP**: Python and C/C++ debugging.
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
- `<leader>rr` - run current file (Python module or C/C++ single file)

## Theme

Default theme is Catppuccin Mocha. Change in `lua/plugins/init.lua` if needed.

## Running Code

- **Python**: Open a `.py` file and press `<leader>rr` (runs `python -m <module>`).
- **C/C++ (single file)**: Open a `.c/.cc/.cpp/.cxx` file and press `<leader>rr`.
  - Runs: `mkdir -p compile && g++ -std=c++20 -O0 -g <file> -o compile/<binary> && compile/<binary>`
  - The file must be inside the current working directory.

## Troubleshooting

- If plugins fail to install, check internet and restart Neovim.
- For Python, ensure `python` and `pip` are installed.
- For LSP: Mason installs Pyright automatically; clangd is expected from your system PATH.
- For C/C++ debugging: install `codelldb` (recommended) or `lldb-vscode` so `nvim-dap` can launch the debugger.
- For C/C++ compiling: ensure `g++` is installed and in PATH.

## Arch Linux (recommended packages)

```bash
sudo pacman -S neovim clang codelldb
```
