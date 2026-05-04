# nvim4python

Neovim config for Python, C/C++, and Typst.

It includes:

- dashboard via `alpha-nvim`
- file explorer via `neo-tree`
- search via `telescope`
- LSP/completion via `nvim-lspconfig`, `mason`, `cmp`
- Python/C/C++/Typst treesitter support
- debugging via `nvim-dap` and `nvim-dap-python`
- Typst watch + Zathura preview
- `kitty` runner with fallback to a built-in floating terminal

## Install

1. Copy `config/*` into `~/.config/nvim/`
2. Start `nvim`
3. Let `lazy.nvim` install plugins

Neovim `0.9+` is required.

## Important Behavior

- `<leader>r`
  - `.py` and `.c/.cc/.cpp/.cxx` run in a new `kitty` window if `kitty` exists
  - if `kitty` is missing, they fall back to the built-in floating terminal in Neovim
  - `.typ/.typst` toggles `typst watch`
- `<leader>R`
  - always runs `.py` and `.c/.cc/.cpp/.cxx` in the built-in floating terminal
- Typst PDFs are written into a `pdf/` directory next to the source file
  - example: `notes/main.typ` -> `notes/pdf/main.pdf`

## Keymaps

`<leader>` = `Space`

### Navigation and Search

- `<leader>e` - toggle Neo-tree
- `<leader>ff` - find files
- `<leader>fg` - live grep
- `<leader>fb` - buffers
- `<leader>fh` - help tags
- `<leader>gs` - git status
- `<leader>gc` - git commits
- `<leader>gb` - git branches

### Run and Utilities

- `<leader>r` - run current file
- `<leader>R` - run current file in floating terminal
- `<leader>s` - stop current run or Typst watch
- `<leader>fr` - rename current file
- `<leader>br` - rename current buffer
- `<leader>hh` - toggle floating `htop`
- `<leader>dR` - `ruff check --fix` + `ruff format`

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

## Required Binaries

Recommended in `PATH`:

- `python` or `python3`
- `g++`
- `ruff`
- `typst`
- `zathura`
- `zathura-pdf-poppler`

Useful but optional:

- `kitty`
  - used by `<leader>r` for Python/C/C++
  - if missing, the config falls back to the built-in floating terminal
- `clangd`
- `pyright`
- `tinymist`
- `lua-language-server`
- `lldb-vscode`
  - only needed for C/C++ debugging

## Arch Linux

Core packages:

```bash
sudo pacman -S --needed neovim python gcc clang ruff typst zathura zathura-pdf-poppler kitty
```

LSP/debug extras:

```bash
sudo pacman -S --needed pyright tinymist lua-language-server lldb
```

Notes:

- `clangd` comes from `clang`
- this README intentionally does not use `codelldb`
- `lldb` is enough for the config because it looks for `lldb-vscode`

## Void Linux

Core packages:

```bash
sudo xbps-install -Su neovim python3 gcc clang ruff typst zathura zathura-pdf-poppler kitty
```

LSP extras:

```bash
sudo xbps-install -Su pyright tinymist lua-language-server
```

Notes:

- package names above were checked locally with `xbps-query`
- if your `Void` setup exposes `clangd` or `lldb-vscode` from a different package split, verify with:

```bash
xbps-query -Rs clang
xbps-query -Rs lldb
```

## Typst Preview

For PDF preview, install both:

- `zathura`
- `zathura-pdf-poppler`

Without `zathura-pdf-poppler`, Zathura opens but PDF support is missing.

## Reloading Config

For a single file:

```vim
:luafile ~/.config/nvim/lua/config/keymaps.lua
```

For a broader reload:

```vim
:source ~/.config/nvim/init.lua
```

In practice, after larger changes, restarting `nvim` is the safer option.
