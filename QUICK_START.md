# Quick Start

## First Launch

1. Make sure a C compiler is on your `PATH` (`gcc` preferred, `clang` as fallback — this is auto-detected, see [lua/config/options.lua](lua/config/options.lua)).
2. Start Neovim:
   ```bash
   nvim
   ```
3. LazyVim installs all plugins automatically on first run.
4. Once it's done, run `:TSUpdate` to compile Treesitter parsers.
5. Optional: open `:Mason` to install any formatters/linters you want (e.g. `stylua`, `black`, `isort`, `shfmt`, `markdownlint`).

## Your First 5 Minutes

| Key                           | What it does                                         |
| ----------------------------- | ---------------------------------------------------- |
| `<Space>` (leader), then wait | which-key pops up showing every available keybinding |
| `<leader>e`                   | Toggle the file explorer (Neo-tree)                  |
| `<leader>ff`                  | Find files                                           |
| `<leader>fg`                  | Search text across the project                       |
| `<leader><leader>`            | Command palette / fuzzy command finder               |
| `gd`                          | Go to definition (once an LSP server is attached)    |
| `K`                           | Hover documentation                                  |
| `<C-j>`                       | Accept a Copilot suggestion                          |
| `<C-\>`                       | Open a floating terminal                             |

For the full breakdown of every plugin — what it does, its cheat sheet, and a link to its docs — see the **[Plugin Guide](CONFIGURATION_GUIDE.md)**.

## Maintenance

```vim
:Lazy sync      " update/sync plugins
:Mason update   " update installed LSP servers/formatters/linters
:TSUpdate       " rebuild Treesitter parsers
:checkhealth    " diagnose issues
```
