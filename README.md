# nvim4python

Opinionated, full-featured Neovim configuration focused on Python development.

## Requirements

- Neovim 0.9+
- Git
- Python 3 (for Pyright, DAP, and helper commands)

## Installation

1. Copy the files from this repository to `~/.config/nvim`:
   ```bash
   cp -r /path/to/nvim4python/* ~/.config/nvim/
   ```
2. Launch Neovim. Lazy.nvim will automatically install plugins.

## What is Included

- **Dashboard**: Alpha-nvim with a custom ASCII header and quick actions.
- **Themes**: 14 dark themes: Catppuccin Mocha, TokyoNight, Gruvbox, OneDark, Nightfox, Kanagawa, Dracula, Everforest, Ayu Dark, Material, GitHub Dark, Nord, Rose Pine, Sonokai. Theme choice is persisted.
- **LSP**: Pyright (strict) for Python and Lua LSP for config editing.
- **Completion**: nvim-cmp with LuaSnip integration.
- **Treesitter**: Syntax highlighting for Python, Lua, Vim, Vimdoc, Query.
- **Telescope**: File, text, buffer, and git pickers.
- **Neo-tree**: File explorer with git/diagnostics.
- **Statusline/Bufferline**: Lualine + Bufferline.
- **Git**: Gitsigns with hunk actions.
- **Debugging**: nvim-dap + nvim-dap-python.
- **Terminal**: Built-in terminal helpers with easy split open.
- **Editing Helpers**: Comment, autopairs, indent guides, surround.
- **Window Tools**: WinShift for moving windows.
- **Testing**: Pytest runner with quickfix integration.

## Keybindings (Highlights)

- `<leader>` = space
- `<leader>e` - toggle Neo-tree
- `<leader>ef` - focus Neo-tree
- `<leader>er` - reveal current file in Neo-tree
- `<leader>ff` - find files (Telescope)
- `<leader>fg` - live grep
- `<leader>fb` - list buffers
- `<leader>fh` - help tags
- `<leader>gs` - git status (Telescope)
- `<leader>gc` - git commits (Telescope)
- `<leader>gb` - git branches (Telescope)
- `<leader>ts` - select theme (Telescope picker)
- `<leader>tt` - open terminal split
- `<leader>fr` - rename current file
- `<leader>pv` - create project venv in `.venv`
- `<leader>pr` - run current Python file as module
- `<leader>tp` - run pytest (quickfix)
- `<Tab>` / `<S-Tab>` - next/previous buffer
- `<leader>bn` / `<leader>bp` - next/previous buffer
- `<leader>bd` - delete buffer
- `<C-l>` - close other buffers
- `gd` - go to definition
- `gr` - go to references
- `K` - hover documentation
- `<leader>ca` - code action
- `<leader>f` - format
- `<F5>` - start/continue debug
- `<F10>` / `<F11>` / `<F12>` - step over/into/out
- `<leader>b` - toggle breakpoint
- `<leader>B` - set conditional breakpoint
- `<leader>dr` - open debug REPL
- `<leader>dl` - run last debug session
- `<C-W>m` - WinShift (move window)
- `<Esc>` (terminal) - return to normal mode

## Theme

Default theme is `catppuccin-mocha`. The selected theme is saved under Neovim state and restored on startup.

## Troubleshooting

- If plugins fail to install, check internet and restart Neovim.
- For Python tooling, ensure `python` is available in your PATH.
