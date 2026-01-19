# nvim4python

Opinionated Neovim config for Python development with fast keymaps, ready-to-use LSP, and Typst support.

## Requirements

- Neovim 0.9+
- Git
- Python 3 (`python` or `python3`) and `pip`
- `ripgrep` (Telescope live_grep)
- `fd` (faster Telescope find_files)
- `typst` (Typst compile/watch)
- `zathura` (PDF preview for Typst)
- `pytest` (test runner command)
- `debugpy` (debugging via nvim-dap-python)

## Installation

1. Copy this config to `~/.config/nvim`:
   ```bash
   cp -r /path/to/nvim4python/* ~/.config/nvim/
   ```
2. Launch Neovim. Lazy.nvim will install plugins.
3. Mason will install LSP servers: `pyright`, `ruff`, `lua_ls`, `tinymist`.

## What’s Included

- **Dashboard**: alpha-nvim with a custom header.
- **Themes**: 14 themes, selection via Telescope, persisted on restart.
- **LSP**: Python (Pyright + Ruff), Lua (lua_ls), Typst (Tinymist).
- **Autocomplete**: nvim-cmp + LuaSnip.
- **Treesitter**: Python, Lua, Vim, Vimdoc, Query, Typst.
- **Search**: Telescope (files, grep, buffers, git).
- **Files**: Neo-tree with git and diagnostics.
- **Status/Buffers**: lualine + bufferline.
- **Git**: gitsigns.
- **Debug**: nvim-dap + nvim-dap-python.
- **Terminal**: quick split terminal.
- **Editing**: Comment, Autopairs, Indent Blankline, Surround.
- **Windows**: WinShift.
- **Typst**: compile/preview/watch with autosave.
- **Tests**: pytest in quickfix.

## Keybindings (Highlights)

- `<leader>` = space
- Files/Search: `<leader>ff`, `<leader>fg`, `<leader>fb`, `<leader>fh`
- Git (Telescope): `<leader>gs`, `<leader>gc`, `<leader>gb`
- Neo-tree: `<leader>e`, `<leader>ef`, `<leader>er`
- Themes: `<leader>uc` (cycle), `<leader>us` (select)
- Buffers: `<Tab>`, `<S-Tab>`, `<leader>bn`, `<leader>bp`, `<leader>bd`, `<C-l>`
- LSP: `gd`, `gr`, `K`, `<leader>ca`, `<leader>f`
- DAP: `<F5>`, `<F10>`, `<F11>`, `<F12>`, `<leader>b`, `<leader>B`, `<leader>dr`, `<leader>dl`
- Python: `<leader>pv` (venv), `<leader>pr` (run module), `<leader>pt` (pytest)
- Typst: `<leader>tc` (compile), `<leader>tv` (preview), `<leader>tw` (watch), `<leader>ts` (stop)
- Terminal: `<leader>ot`
- WinShift: `<C-W>m`

## Notes

- If `typst` or `zathura` is missing, Typst commands will notify you.
- For debugging, ensure `debugpy` is installed in the active Python environment.
- `live_grep` requires `ripgrep` in PATH.
