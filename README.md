# nvim4python

Neovim config for Python, C/C++, and Typst.

It includes:

- dashboard via `snacks.nvim`
- file explorer via `neo-tree`
- search via `telescope`
- LSP/completion via `nvim-lspconfig`, `mason`, `cmp`
- statusline via `lualine` and buffers via `bufferline`
- debugging via `nvim-dap` and `nvim-dap-python`
- Typst watch + Zathura preview
- `alacritty` runner with fallback to a built-in floating terminal
- theme picker with multiple bundled colorschemes

## Install

### Automatic

```bash
python install.py
```

The script detects your package manager (pacman or xbps), installs required
packages, and copies the config into `~/.config/nvim/`.

If `~/.dotfiles` exists, config is placed under `~/.dotfiles/.config/nvim/`
instead.

### Manual

1. Copy `config/*` into `~/.config/nvim/`
2. Start `nvim`
3. Let `lazy.nvim` install plugins

Neovim `0.11+` is required.

## Important Behavior

- dashboard is opened by default and also on `<leader>q`
- dashboard shows `Recent files`, `cwd`, and `theme`
- dashboard `e` key opens a new-file prompt — enter a filename or just an
  extension (`.py`, `.cpp`, `.typst`) to get a pre-filled template
- `<leader>r`
  - `.py` and `.c/.cc/.cpp/.cxx` run in a new `alacritty` window if `alacritty` exists
  - if `alacritty` is missing, they fall back to the built-in floating terminal in Neovim
  - `.typ/.typst` toggles `typst watch`
- `<leader>R`
  - always runs `.py` and `.c/.cc/.cpp/.cxx` in the built-in floating terminal
- `<leader>t`
  - opens the theme picker
- C/C++ is compiled with `g++ -std=c++20 -O0 -g` and the binary is placed in
  a `compile/` directory next to the source file
- Typst PDFs are written into a `pdf/` directory next to the source file
  - example: `notes/main.typ` -> `notes/pdf/main.pdf`

## Keymaps

`<leader>` = `Space`

### Navigation and Search

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle Neo-tree |
| `<Tab>` | Toggle focus between Neo-tree and editor |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>gs` | Git status |
| `<leader>gc` | Git commits |
| `<leader>gb` | Git branches |

### Run and Utilities

| Key | Action |
|-----|--------|
| `<leader>r` | Run current file (alacritty / floating terminal) |
| `<leader>R` | Run current file in floating terminal |
| `<leader>s` | Stop current run or Typst watch |
| `<leader>t` | Open theme picker |
| `<leader>q` | Open dashboard |
| `<leader>fr` | Rename current file on disk |
| `<leader>br` | Rename current buffer |
| `<leader>dR` | `ruff check --fix` + `ruff format` on current file |

### Buffers

| Key | Action |
|-----|--------|
| `<leader>.` | Next buffer |
| `<leader>,` | Previous buffer |
| `<leader>bn` | New buffer |
| `<leader>bd` | Close current buffer |
| `<leader>bo` | Close all other buffers |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover |
| `<leader>la` | Code action |
| `<leader>lf` | Format |

### DAP (Debugger)

| Key | Action |
|-----|--------|
| `<leader>dc` | Continue |
| `<leader>do` | Step over |
| `<leader>di` | Step into |
| `<leader>du` | Step out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dr` | REPL |
| `<leader>dl` | Run last |

### Git (Gitsigns)

| Key | Mode | Action |
|-----|------|--------|
| `]c` | n | Next hunk |
| `[c` | n | Previous hunk |
| `<leader>hs` | n/v | Stage hunk |
| `<leader>hr` | n/v | Reset hunk |
| `<leader>hS` | n | Stage buffer |
| `<leader>hu` | n | Undo stage hunk |
| `<leader>hR` | n | Reset buffer |
| `<leader>hp` | n | Preview hunk |
| `<leader>hb` | n | Blame line (full) |
| `<leader>hB` | n | Toggle line blame |
| `<leader>hd` | n | Diff this |
| `<leader>hD` | n | Diff this ~ |
| `<leader>hT` | n | Toggle deleted |

### Visual Mode

| Key | Action |
|-----|--------|
| `/` | Toggle comment on selection |
| `>` | Indent right (keep selection) |
| `<` | Indent left (keep selection) |

## Virtual Environments

Python runner and Pyright automatically detect the active virtualenv by:

1. `$VIRTUAL_ENV` environment variable
2. `.venv`, `venv`, `.env`, or `env` directory at the project root
3. Project root is determined by the nearest `pyproject.toml`, `setup.py`,
   `setup.cfg`, `requirements.txt`, `Pipfile`, `poetry.lock`, or `.git`

If no virtualenv is found, the system `python3` / `python` is used.

## Required Binaries

Recommended in `PATH`:

- `python` or `python3`
- `g++`
- `ruff`
- `typst`
- `zathura`
- `zathura-pdf-poppler`

Useful but optional:

- `alacritty`
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
sudo pacman -S --needed neovim python gcc clang ruff typst zathura zathura-pdf-poppler alacritty
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
sudo xbps-install -Su neovim python3 gcc clang ruff typst zathura zathura-pdf-poppler alacritty
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
