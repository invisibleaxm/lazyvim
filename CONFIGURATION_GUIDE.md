# Plugin Guide — Getting to Know Your Setup

This is a tour of the plugins actually selected/customized in this config, organized by what they're for. Each entry covers **what it does**, a **quick cheat sheet**, and a **link to the official project** for the full docs.

> This config is built on [LazyVim](https://www.lazyvim.org/) — a curated Neovim "distro". LazyVim itself already brings in a large default plugin set (Telescope, Neo-tree, which-key, gitsigns, lualine, bufferline, flash.nvim, mini.nvim, noice.nvim, Trouble, and more). See the [LazyVim plugin list](https://www.lazyvim.org/plugins) for everything included out of the box. Below is what's specifically configured or added on top of that foundation, in [lua/plugins/](lua/plugins).

---

## Owner Files and Feature Toggles

Use this as the "single source of truth" map when deciding where to edit behavior.

| Area                          | Owner file                                                     | Optional extension files                                 | Toggle                                                                        |
| ----------------------------- | -------------------------------------------------------------- | -------------------------------------------------------- | ----------------------------------------------------------------------------- |
| LSP servers and diagnostics   | [lua/plugins/lsp.lua](lua/plugins/lsp.lua)                     | [lua/plugins/powershell.lua](lua/plugins/powershell.lua) | `vim.g.enable_powershell = false` disables PowerShell-specific additions only |
| Completion engine and ranking | [lua/plugins/completion.lua](lua/plugins/completion.lua)       | [lua/plugins/copilot.lua](lua/plugins/copilot.lua)       | `vim.g.ai_cmp = true` keeps Copilot in completion-menu mode                   |
| PowerShell IDE features       | [lua/plugins/powershell.lua](lua/plugins/powershell.lua)       | none                                                     | `vim.g.enable_powershell = false` disables this entire file                   |
| Terminal and REPL flow        | [lua/plugins/toggleterm.lua](lua/plugins/toggleterm.lua)       | [lua/plugins/powershell.lua](lua/plugins/powershell.lua) | inherits `vim.g.enable_powershell` for PowerShell helpers                     |
| Notifications and message UI  | [lua/plugins/notifications.lua](lua/plugins/notifications.lua) | [lua/plugins/disabled.lua](lua/plugins/disabled.lua)     | VSCode mode short-circuits these automatically                                |

Notes:

- If an extension file is disabled, the owner file still works.
- Keep "base behavior" in owner files and filetype/tool-specific behavior in extension files.

---

## LSP & Language Servers

**[lua/plugins/lsp.lua](lua/plugins/lsp.lua)** · powered by [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason.nvim](https://github.com/mason-org/mason.nvim)

Provides IDE features (go-to-definition, hover docs, diagnostics, rename, etc.) via language servers, auto-installed through Mason. Configured servers: `pyright` & `ruff` (Python), `rust_analyzer` (Rust), `lua_ls` (Lua), `yamlls`, `bashls`, `dockerls`, `marksman` (Markdown), `ansiblels`, `azure_pipelines_ls`, plus `powershell_es` (see PowerShell section below).

**Cheat sheet** (standard LazyVim LSP keymaps):

| Key            | Action                                               |
| -------------- | ---------------------------------------------------- |
| `gd`           | Go to definition                                     |
| `gr`           | Go to references                                     |
| `gi`           | Go to implementation                                 |
| `K`            | Hover documentation                                  |
| `<leader>ca`   | Code actions                                         |
| `<leader>rn`   | Rename symbol                                        |
| `]d` / `[d`    | Next/previous diagnostic                             |
| `:Mason`       | Install/manage LSP servers, formatters, linters      |
| `:LspInfo`     | Check which server is attached to the current buffer |
| `:checkhealth` | Diagnose LSP/plugin setup issues                     |

🔗 [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) · [mason.nvim](https://github.com/mason-org/mason.nvim) · [LazyVim LSP docs](https://www.lazyvim.org/plugins/lsp)

---

## Completion

**[lua/plugins/completion.lua](lua/plugins/completion.lua)** · [blink.cmp](https://github.com/Saghen/blink.cmp) + [LuaSnip](https://github.com/L3MON4D3/LuaSnip)

The autocompletion popup while typing. Sources are prioritized: LSP first, then Copilot, then snippets, then buffer words, then file paths.

**Cheat sheet:**

| Key                 | Action                                                                 |
| ------------------- | ---------------------------------------------------------------------- |
| `<Tab>` / `<S-Tab>` | Next/previous item (or accept Copilot / expand snippet if menu closed) |
| `<CR>`              | Confirm the selected item                                              |
| `<Up>` / `<Down>`   | Move up/down the popup list                                            |

🔗 [blink.cmp](https://github.com/Saghen/blink.cmp) · [LuaSnip](https://github.com/L3MON4D3/LuaSnip)

---

## GitHub Copilot

**[lua/plugins/copilot.lua](lua/plugins/copilot.lua)** · [copilot.lua](https://github.com/zbirenbaum/copilot.lua) + Blink source integration

Copilot suggestions are integrated into the completion menu path (`vim.g.ai_cmp = true`) so you use one acceptance model instead of mixed ghost-text and menu workflows.

**Cheat sheet:**

| Key               | Action                   |
| ----------------- | ------------------------ |
| `<C-j>`           | Accept full suggestion   |
| `<C-Right>`       | Accept next word only    |
| `<C-l>`           | Accept current line only |
| `<M-]>` / `<M-[>` | Next/previous suggestion |
| `<C-]>`           | Dismiss suggestion       |

🔗 [copilot.lua](https://github.com/zbirenbaum/copilot.lua) · [GitHub Copilot](https://github.com/features/copilot)

---

## Syntax & Structural Editing

**[lua/plugins/treesitter.lua](lua/plugins/treesitter.lua)** · [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) + [nvim-treehopper](https://github.com/mfussenegger/nvim-treehopper)

Treesitter parses your code into a real syntax tree for accurate highlighting, indentation, and folding. Treehopper lets you target syntax nodes directly for edits.

**Cheat sheet:**

| Key                                                       | Action                                                         |
| --------------------------------------------------------- | -------------------------------------------------------------- |
| _(automatic)_                                             | Highlighting/indentation just works once a parser is installed |
| `m` (in operator-pending or visual mode, e.g. `dm`, `vm`) | Select the nearest syntax node (function call, block, etc.)    |
| `:TSUpdate`                                               | Update/compile parsers                                         |

🔗 [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) · [nvim-treehopper](https://github.com/mfussenegger/nvim-treehopper)

---

## Code Folding

**[lua/plugins/folding-plugins.lua](lua/plugins/folding-plugins.lua)** · [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) + [fold-cycle.nvim](https://github.com/jghauser/fold-cycle.nvim)

Smarter code folding than vanilla Neovim — picks the best available fold source per filetype (LSP `foldingRange` when the server supports it, otherwise Treesitter, otherwise indentation).

**Cheat sheet** (standard Vim fold commands, enhanced by nvim-ufo):

| Key         | Action                       |
| ----------- | ---------------------------- |
| `zo` / `zc` | Open/close fold under cursor |
| `za`        | Toggle fold under cursor     |
| `zR`        | Open all folds               |
| `zM`        | Close all folds              |

🔗 [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) · [fold-cycle.nvim](https://github.com/jghauser/fold-cycle.nvim)

---

## Formatting & Linting

**[lua/plugins/formatting.lua](lua/plugins/formatting.lua)** · [conform.nvim](https://github.com/stevearc/conform.nvim) (linting via [nvim-lint](https://github.com/mfussenegger/nvim-lint) is present but disabled by default)

Runs formatters per filetype: `stylua` (Lua), `black`/`isort` (Python), `shfmt` (Shell). Install the actual formatter binaries via `:Mason`.

**Cheat sheet:**

| Key            | Action                                                   |
| -------------- | -------------------------------------------------------- |
| `<leader>cf`   | Format the current buffer                                |
| `:ConformInfo` | See which formatter is configured/active for this buffer |

🔗 [conform.nvim](https://github.com/stevearc/conform.nvim) · [nvim-lint](https://github.com/mfussenegger/nvim-lint)

---

## File Explorer & Fuzzy Finding

**[lua/plugins/neotree.lua](lua/plugins/neotree.lua)** · [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)
**[lua/plugins/telescope.lua](lua/plugins/telescope.lua)** · [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) + [telescope-fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim)

Neo-tree is the sidebar file browser (dotfiles hidden by default here). Telescope is the fuzzy finder for files, text search, buffers, and more, accelerated by the native `fzf` sorter.

**Cheat sheet:**

| Key          | Action                                       |
| ------------ | -------------------------------------------- |
| `<leader>e`  | Toggle file explorer (Neo-tree)              |
| `<leader>ff` | Find files                                   |
| `<leader>fg` | Live grep (search text across files)         |
| `<leader>fb` | Browse open buffers                          |
| `<leader>fp` | Find a file inside your Neovim plugin config |
| `<leader>sn` | Search notification history                  |

🔗 [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) · [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

---

## Notifications & Messages UI

**[lua/plugins/notifications.lua](lua/plugins/notifications.lua)** · [noice.nvim](https://github.com/folke/noice.nvim) + [nvim-notify](https://github.com/rcarriga/nvim-notify)

Replaces the plain command line and message area with a nicer UI, and shows `vim.notify()` calls as pop-up toasts (5s timeout here) instead of only `:messages`.

**Cheat sheet:**

| Key / Command                | Action                                                                          |
| ---------------------------- | ------------------------------------------------------------------------------- |
| `:Noice` or `:Noice history` | Reopen the full message/notification history (use this since popups disappear!) |
| `:Noice last`                | Redisplay the most recent notification                                          |
| `<leader>un`                 | Dismiss all visible notifications                                               |
| `<leader>nh`                 | Notification history (via Telescope)                                            |

🔗 [noice.nvim](https://github.com/folke/noice.nvim) · [nvim-notify](https://github.com/rcarriga/nvim-notify)

---

## PowerShell Development

**[lua/plugins/powershell.lua](lua/plugins/powershell.lua)** · [PowerShellEditorServices](https://github.com/PowerShell/PowerShellEditorServices) (via `powershell_es` in nvim-lspconfig) + custom snippets

Full PowerShell IDE support: LSP diagnostics/formatting via PSScriptAnalyzer, plus a few custom snippets and script-runner keymaps.

**Cheat sheet:**

| Key                                         | Action                                   |
| ------------------------------------------- | ---------------------------------------- |
| `<leader>pr`                                | Run the current script                   |
| `<leader>pt`                                | Run Pester tests                         |
| `<leader>pa`                                | Run PSScriptAnalyzer on the current file |
| `<leader>ph`                                | `Get-Help` lookup                        |
| `<leader>pf`                                | Format the current file                  |
| `func`, `param`, `try`, `foreach` + `<Tab>` | Expand custom snippets in `.ps1` files   |

🔗 [PowerShellEditorServices](https://github.com/PowerShell/PowerShellEditorServices)

---

## Terminal & REPL Integration

**[lua/plugins/toggleterm.lua](lua/plugins/toggleterm.lua)** · [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) + [vim-slime](https://github.com/jpalardy/vim-slime) (using an [invisibleaxm fork](https://github.com/invisibleaxm/vim-slime))

Toggleterm gives you a quick floating/split terminal. `vim-slime` sends lines/blocks of code to an external terminal pane — tmux on Linux/macOS, or WezTerm on Windows (since tmux isn't available there).

**Cheat sheet:**

| Key                                    | Action                                   |
| -------------------------------------- | ---------------------------------------- |
| `<C-\>`                                | Open/close a floating terminal           |
| `:SlimeConfig`                         | Configure the target tmux/WezTerm pane   |
| `:SlimeSend` / `:SlimeSendCurrentLine` | Send a selection/line to the target pane |

🔗 [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) · [vim-slime](https://github.com/jpalardy/vim-slime)

---

## Diagnostics List

**[lua/plugins/trouble.lua](lua/plugins/trouble.lua)** · [trouble.nvim](https://github.com/folke/trouble.nvim)

A pretty, navigable list for diagnostics, references, quickfix, and LSP results (auto-open/auto-preview turned off here to stay unobtrusive).

**Cheat sheet:**

| Key          | Action                                   |
| ------------ | ---------------------------------------- |
| `<leader>xx` | Toggle diagnostics list (workspace)      |
| `<leader>xX` | Toggle diagnostics list (current buffer) |
| `<leader>cs` | Symbols list                             |

🔗 [trouble.nvim](https://github.com/folke/trouble.nvim)

---

## Markdown & Sharing Tools

**[lua/plugins/markdown.lua](lua/plugins/markdown.lua)** · [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) · [pastify.nvim](https://github.com/TobinPalmer/pastify.nvim) · [nvim-silicon](https://github.com/michaelrommel/nvim-silicon)

Live browser preview for Markdown files, pasting clipboard images directly into a note, and rendering code snippets as shareable images.

**Cheat sheet:**

| Key / Command | Action                                                  |
| ------------- | ------------------------------------------------------- |
| `<C-p>`       | Start Markdown preview                                  |
| `<A-p>`       | Stop Markdown preview                                   |
| `:Pastify`    | Paste an image from the clipboard into the current file |
| `:Silicon`    | Render current selection/buffer as a code screenshot    |

Note: `nvim-silicon` requires the external `silicon` binary installed separately (via Homebrew or the Windows installer).

🔗 [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) · [pastify.nvim](https://github.com/TobinPalmer/pastify.nvim) · [nvim-silicon](https://github.com/michaelrommel/nvim-silicon)

---

## Tmux / Pane Navigation

**[lua/plugins/ui.lua](lua/plugins/ui.lua)** · [tmux.nvim](https://github.com/aserowy/tmux.nvim)

Lets `<C-h/j/k/l>` seamlessly move between Neovim splits _and_ tmux panes as if they were the same grid (Unix/macOS only — needs a small tmux-side config to feel smooth).

🔗 [tmux.nvim](https://github.com/aserowy/tmux.nvim)

---

## Icons

**[lua/plugins/web-devicons.lua](lua/plugins/web-devicons.lua)** · [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)

Custom file-type icons used by Neo-tree/Telescope/bufferline — notably distinct icons for `.ps1`/`.psm1`/`.psd1` and Dockerfiles.

🔗 [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)

---

## VSCode Hybrid Mode

**[lua/plugins/vscode.lua](lua/plugins/vscode.lua)** · [vscode-neovim](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim) extension compatibility layer

Not a plugin itself — this file only activates when Neovim is running _inside_ VSCode via the vscode-neovim extension. It remaps a handful of keys to call native VSCode commands (quick open, find in files, go to definition, rename, etc.) instead of Neovim's own UI plugins, and disables the Neovim-only UI plugins above (Telescope, Neo-tree, Trouble, noice, etc. all short-circuit with `if vim.g.vscode then return {} end`) so there's no conflict.

🔗 [vscode-neovim extension](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim)

---

## Disabling Plugins

**[lua/plugins/disabled.lua](lua/plugins/disabled.lua)**

Currently empty — this is the file to use whenever you want to turn a plugin off, e.g.:

```lua
return {
  { "plugin-name", enabled = false },
}
```

---

## Adding Something New

- **New LSP server:** add an entry to `servers = {}` in [lua/plugins/lsp.lua](lua/plugins/lsp.lua).
- **New plugin:** create a file in [lua/plugins/](lua/plugins) or add a spec to an existing one — see the [LazyVim plugin authoring docs](https://www.lazyvim.org/configuration/plugins) for the spec format.
- **Browse everything currently installed:** `:Lazy`
- **Browse/install LSP servers, formatters, linters, DAP adapters:** `:Mason`

## Handy Commands Reference

| Command        | Purpose                                  |
| -------------- | ---------------------------------------- |
| `:Lazy`        | Plugin manager UI (install/update/clean) |
| `:Mason`       | LSP/formatter/linter installer UI        |
| `:checkhealth` | Diagnose configuration/plugin issues     |
| `:LspInfo`     | See active LSP clients for the buffer    |
| `:TSUpdate`    | Rebuild Treesitter parsers               |
