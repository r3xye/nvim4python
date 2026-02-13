# nvim4python

A Neovim configuration for Python, C/C++, and Typst with a ready-to-use dashboard, LSP, code running, and debugging.

## What's Included

- `alpha-nvim` dashboard with quick actions and fast new-file creation.
- `neo-tree` file explorer.
- `telescope` for file/text/buffer/git search.
- `nvim-lspconfig` + `mason` + `cmp` for LSP and completion.
- LSP servers: `pyright`, `ruff`, `lua_ls`, `tinymist`, `clangd`.
- `nvim-dap` + `nvim-dap-python` for debugging.
- `bufferline` (VS-style) and `lualine` (full path + cwd + current theme).
- `gitsigns`, `which-key`, `nvim-autopairs`, `Comment.nvim`, `indent-blankline`, `toggleterm`.
- Theme collection with Telescope-based picker.

## Installation

1. Install Neovim `0.9+`.
2. Put these files into `~/.config/nvim`.
3. Start Neovim; `lazy.nvim` will install plugins automatically.

## Dashboard

On the start screen, `e` (`New file`) opens a selector:

- `1` -> `Python (.py)`
- `2` -> `C++ (.cpp)`
- `3` -> `Typst (.typ)`
- `q` / `Esc` -> cancel

## Keymaps

`<leader>` = `Space`

### Navigation and Search

- `<leader>e` - toggle Neo-tree
- `<leader>ff` - find files
- `<leader>fg` - live grep
- `<leader>fb` - buffers
- `<leader>fh` - help tags
- `<leader>gs` - git status (Telescope)
- `<leader>gc` - git commits
- `<leader>gb` - git branches

### Run and Utilities

- `<leader>r` - run current file:
  - `.py` -> `python <file>` in a new `kitty` window
  - `.c/.cc/.cpp/.cxx` -> compile with `g++` and run
  - `.typ/.typst` -> toggle `typst watch`
- `<leader>s` - stop current run (or typst watch/preview)
- `<leader>fr` - rename current file
- `<leader>dR` - `ruff check --fix` + `ruff format`

### Editing

- in visual mode: `/` toggles comment for selection
- in visual mode: `>` / `<` keeps selection after indenting

### LSP

- `gd` - definition
- `gr` - references
- `K` - hover
- `<leader>la` - code action
- `<leader>lf` - format

### DAP

- `<leader>dc` - continue
- `<leader>do` - step over
- `<leader>di` - step into
- `<leader>du` - step out
- `<leader>db` - toggle breakpoint
- `<leader>dB` - conditional breakpoint
- `<leader>dr` - REPL
- `<leader>dl` - run last

### Bufferline

- `<leader>bN` - new buffer
- `<leader>bn` - next buffer
- `<leader>bp` - previous buffer
- `<leader>bd` - close buffer
- `<leader>bo` - close other buffers
- `<leader>br` - rename current buffer name

### Themes

- `<leader>t` - open theme picker (Telescope)

## Important Dependencies

Recommended binaries in PATH:

- `python` (or `python3`)
- `g++`
- `clangd`
- `ruff`
- `typst`
- `kitty` (required for `<leader>r` on `.py`/`.cpp`)

For Typst preview:

- `zathura`

For C/C++ debugging:

- `codelldb` (preferred) or `lldb-vscode`

## Arch Linux

Install dependencies via `pacman`:

```bash
sudo pacman -S --needed neovim python gcc clang ruff typst kitty zathura codelldb lldb
```

## Statusline and Tabs

- `lualine` shows:
  - mode
  - git branch/diff/diagnostics
  - **full path of the current file**
  - cwd
  - active theme (`theme:<name>`)
  - encoding/fileformat/filetype
- `bufferline` is configured in a VS-like style with diagnostics and active-buffer indicator.
- `indent-blankline` uses dotted indent guides `┊`.

## Notes

- If highlighting/plugins do not update after changes, restart Neovim.
- To reload a single config file: `:source ~/.config/nvim/lua/config/<file>.lua`.
