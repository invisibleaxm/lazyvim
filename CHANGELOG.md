# Changelog

All notable changes to this Neovim configuration.

## [2026-07-18] - Latest

### ✨ Added
- **vim-slime integration** - Send code to tmux/WezTerm panes with `<F9>`
  - Linux/macOS: Uses tmux for REPL integration
  - Windows: Uses WezTerm for terminal pane targeting
  - Interactive development workflow for Python, PowerShell, Node.js, etc.

### 🔧 Fixed
- **VSCode Integration** - Hybrid mode now works seamlessly
  - Disabled conflicting Neovim plugins when running in VSCode
  - VSCode-specific keybindings in [vscode.lua](lua/plugins/vscode.lua)
  - Use VSCode IntelliSense instead of nvim-cmp in VSCode
  - Use VSCode terminal instead of ToggleTerm in VSCode

### 📚 Improved
- **Less Aggressive Completion** - Better typing experience
  - General files: Completion appears on typing, but `Enter` only confirms if item explicitly selected
  - PowerShell files: Manual trigger only with `Ctrl+Space` (prevents overwhelming popups)
  - Smart source ordering: LSP keywords first, Copilot second, snippets third
  - See [POWERSHELL_DEVELOPMENT.md](docs/POWERSHELL_DEVELOPMENT.md) for details

- **Migrated from null-ls to modern tools**
  - Removed deprecated `null-ls.nvim`
  - Now using `conform.nvim` for formatting (LazyVim default)
  - Now using `nvim-lint` for linting (LazyVim default)
  - All formatters maintained: stylua, black, isort, shfmt, prettier

- **Cross-platform improvements**
  - Better Windows support (compiler setup guide, WezTerm integration)
  - OS-specific feature detection (tmux only on Unix-like systems)
  - PowerShell path detection for Windows/macOS/Linux

### 📖 Documentation
- Added comprehensive [NEOVIM_USER_GUIDE.md](docs/NEOVIM_USER_GUIDE.md) - All keybindings, plugins, workflows
- Added [POWERSHELL_DEVELOPMENT.md](docs/POWERSHELL_DEVELOPMENT.md) - PowerShell IDE features
- Added [POWERSHELL_QUICKREF.md](docs/POWERSHELL_QUICKREF.md) - Quick reference card
- Added [VSCODE_INTEGRATION.md](docs/VSCODE_INTEGRATION.md) - Hybrid mode setup
- Added [CLIPBOARD_MOUSE_GUIDE.md](docs/CLIPBOARD_MOUSE_GUIDE.md) - System integration
- Added [WINDOWS_COMPILER_SETUP.md](WINDOWS_COMPILER_SETUP.md) - C compiler setup
- Updated [scripts/README.md](scripts/README.md) - Setup, bootstrap, cleanup scripts
- Improved [README.md](README.md) - Better quick start instructions

## Earlier Changes

### Initial Modernization
- Updated from 3-year-old config to LazyVim distribution
- Fixed syntax error in [disabled.lua](lua/plugins/disabled.lua)
- Updated LazyVim extras to current paths:
  - `lazyvim.plugins.extras.ui.mini-animate` → `lazyvim.plugins.extras.editor.mini-files`
  - `lazyvim.plugins.extras.coding.copilot` → `lazyvim.plugins.extras.ai.copilot`
- Added modern extras: `coding.luasnip`, `util.mini-hipatterns`
- Pre-configured 15+ LSP servers with auto-installation
- Added DAP debugging with F5-F12 keybindings
- GitHub Copilot integration with optimized keymaps
- Treesitter syntax highlighting for 40+ languages
- Telescope fuzzy finder with FZF native performance
- Smart code folding with multiple backends

---

## Feature Summary

### Current Features
- ✅ **LazyVim** - Modern Neovim distribution
- ✅ **LSP Servers** - 15+ pre-configured languages
- ✅ **GitHub Copilot** - AI-powered completions
- ✅ **DAP Debugging** - Full debugging support
- ✅ **VSCode Integration** - Hybrid mode
- ✅ **PowerShell IDE** - Full IntelliSense and tooling
- ✅ **Smart Completion** - Less aggressive, context-aware
- ✅ **Treesitter** - Advanced syntax highlighting
- ✅ **Telescope** - Fuzzy finder
- ✅ **vim-slime** - REPL integration
- ✅ **Cross-platform** - Windows, macOS, Linux
- ✅ **Auto-formatting** - Format on save
- ✅ **Terminal Integration** - ToggleTerm + PowerShell
- ✅ **Clipboard/Mouse** - System integration

---

For more details, see the full documentation in the [docs/](docs/) directory.
