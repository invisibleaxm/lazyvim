# Neovim Configuration - Modernized Setup

## Overview
This Neovim configuration has been modernized from a 3-year-old setup to work seamlessly with the latest LazyVim distribution. It's cross-platform (Windows, macOS, Linux) and includes excellent VSCode integration.

## What Was Fixed

### 1. **Syntax Error** ✅
- Fixed invalid `test,` entry in `lua/plugins/disabled.lua` that was causing startup failures

### 2. **Updated LazyVim Extras** ✅
The following extras were updated to current paths:
- `lazyvim.plugins.extras.ui.mini-animate` → `lazyvim.plugins.extras.editor.mini-files`
- `lazyvim.plugins.extras.coding.copilot` → `lazyvim.plugins.extras.ai.copilot`
- Added modern extras: `coding.luasnip`, `util.mini-hipatterns`

### 3. **Enhanced VSCode Integration** ✅
- Created dedicated `lua/plugins/vscode.lua` for VSCode-specific keybindings
- Keymaps now automatically adapt when running inside VSCode
- Seamless navigation, file management, and LSP features in VSCode

### 4. **Cross-Platform Keymaps** ✅
- Keymaps now detect OS and only load platform-specific features
- Tmux integration only loads on Unix-like systems
- Better descriptions for all keybindings

### 5. **Migrated to Modern Formatting/Linting** ✅
- Removed deprecated `null-ls.nvim` configuration (was causing errors)
- Now using `conform.nvim` for formatting (LazyVim's default)
- Now using `nvim-lint` for linting (LazyVim's default)
- All your previous formatters (stylua, black, isort, shfmt) and linters (flake8, markdownlint, luacheck) are configured

## Key Features

### ✨ Included Plugins & Features
- **Language Support**: Go, JSON, Rust, PowerShell, Python, Lua, and more
- **LSP Servers**: Pre-configured for 15+ languages
- **Debugger (DAP)**: Full debugging support with F5-F12 keybindings
- **AI Tools**: GitHub Copilot integration
- **Formatting**: Prettier, Black, Stylua, and more
- **Telescope**: Enhanced fuzzy finding with FZF native
- **Treesitter**: Syntax highlighting and code understanding
- **Folding**: Smart code folding support

### 🎯 Cross-Platform Support
- **Windows**: PowerShell configuration, Python path detection
- **macOS**: Python path detection, Mac-specific Alt key mappings
- **Linux**: Full Unix tool support, tmux integration

### 🎨 VSCode Integration
When running in VSCode, the config automatically:
- Loads VSCode-specific keybindings
- Disables UI plugins that conflict with VSCode
- Maintains all editing features (motions, text objects, etc.)

## Quick Start

### Prerequisites - C Compiler (Cross-Platform)
Neovim Treesitter requires a C compiler to build syntax parsers.

**Windows**:
```powershell
# Install LLVM/Clang (recommended)
winget install LLVM.LLVM
# Or: scoop install llvm
```

**macOS**:
```bash
# Install Xcode Command Line Tools (includes clang)
xcode-select --install
```

**Linux**:
```bash
# Debian/Ubuntu - gcc usually pre-installed, but to be sure:
sudo apt install build-essential

# Or install clang:
sudo apt install clang

# Fedora/RHEL:
sudo dnf install gcc-c++
# Or: sudo dnf install clang
```

After installing, restart your terminal. Windows users see [WINDOWS_COMPILER_SETUP.md](WINDOWS_COMPILER_SETUP.md) for detailed instructions.

### First Time Setup
1. Backup your old config (if not already done):
   ```powershell
   # Windows
   Rename-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.backup

   # macOS/Linux
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. Launch Neovim:
   ```bash
   nvim
   ```

3. LazyVim will automatically:
   - Clone the lazy.nvim plugin manager
   - Install all plugins
   - Set up LSP servers via Mason

### Using with VSCode
1. Install the [VSCode Neovim extension](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim)
2. In VSCode settings, point to your init.lua:
   ```json
   {
     "vscode-neovim.neovimInitVimPaths.windows": "C:\\Users\\alexc\\AppData\\Local\\nvim\\init.lua",
     "vscode-neovim.neovimExecutablePaths.windows": "nvim"
   }
   ```

## Key Bindings

### Leader Key
The leader key is `<Space>` (default LazyVim setting)

### Essential Keybindings

#### File Navigation
- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Browse buffers
- `<leader>fp` - Find plugin files

#### LSP & Code
- `gd` - Go to definition
- `gr` - Go to references
- `gi` - Go to implementation
- `K` - Show hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol

#### Debugging (DAP)
- `<F5>` - Continue/Start debugging
- `<Shift-F5>` - Stop debugging
- `<F8>` - Toggle breakpoint
- `<F10>` - Step over
- `<F11>` - Step into
- `<F12>` - Step out
- `<leader>dh` - DAP hover
- `<leader>dP` - DAP preview

#### Editor Enhancements
- `<C-d>` - Scroll down (centered)
- `<C-u>` - Scroll up (centered)
- `J` - Join lines (cursor stays in place)
- `n`/`N` - Next/Previous search (centered)
- `<leader>y` - Yank to system clipboard
- `YY` - Copy code block inside `{}`

#### Mac-Specific (Alt+j/k for moving lines)
- `∆` (Alt+j) - Move line/selection down
- `˚` (Alt+k) - Move line/selection up

## Customization

### Adding Language Servers
Edit `lua/plugins/lsp.lua` and add to the `servers` table:
```lua
servers = {
  your_lsp = {
    settings = {
      -- LSP-specific settings
    }
  }
}
```

### Adding Plugins
Create a new file in `lua/plugins/` or add to existing files:
```lua
return {
  {
    "author/plugin-name",
    config = function()
      -- plugin configuration
    end
  }
}
```

### Disabling Plugins
Edit `lua/plugins/disabled.lua`:
```lua
return {
  { "plugin-name", enabled = false },
}
```

## Installed Language Servers (via Mason)
- bicep-lsp
- pyright (Python)
- ruff-lsp (Python linter)
- gopls (Go)
- lua-ls (Lua)
- rust-analyzer (Rust)
- powershell-es (PowerShell)
- bashls (Bash)
- ansiblels (Ansible)
- yamlls (YAML)
- jsonls (JSON)
- marksman (Markdown)
- dockerls (Docker)

## Troubleshooting

### Plugins Not Loading
```vim
:Lazy sync
```

### LSP Not Working
```vim
:Mason
" Install missing servers from the UI
```

### Check Health
```vim
:checkhealth
```

### Update Everything
```vim
:Lazy sync
:Mason update
:TSUpdate
```

## File Structure
```
nvim/
├── init.lua                    # Entry point
├── lazy-lock.json              # Plugin versions lockfile
├── lazyvim.json                # LazyVim config
├── lua/
│   ├── config/
│   │   ├── autocmds.lua        # Auto commands
│   │   ├── keymaps.lua         # Key mappings
│   │   ├── lazy.lua            # Lazy.nvim setup
│   │   └── options.lua         # Vim options
│   └── plugins/
│       ├── completion.lua      # Completion config
│       ├── disabled.lua        # Disabled plugins
│       ├── folding-plugins.lua # Code folding
│       ├── formatting.lua      # Formatting & linting (NEW)
│       ├── lsp.lua             # LSP configuration
│       ├── markdown.lua        # Markdown support
│       ├── neotree.lua         # File tree
│       ├── telescope.lua       # Fuzzy finder
│       ├── toggleterm.lua      # Terminal
│       ├── treesitter.lua      # Syntax highlighting
│       ├── trouble.lua         # Diagnostics
│       ├── ui.lua              # UI enhancements
│       ├── vscode.lua          # VSCode integration (NEW)
│       └── web-devicons.lua    # Icons
└── spell/                      # Spell check dictionaries
```

## Tips & Tricks

1. **Which-key**: Press `<leader>` and wait to see available keybindings
2. **Command Palette**: Use `<leader><leader>` for command fuzzy finding
3. **File Explorer**: `<leader>e` toggles the file explorer (Neo-tree)
4. **Terminal**: `<leader>ft` opens a floating terminal
5. **Lazy UI**: `:Lazy` opens the plugin manager interface
6. **Mason UI**: `:Mason` opens the LSP/DAP/linter installer

## Resources
- [LazyVim Documentation](https://www.lazyvim.org/)
- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)
- [Mason.nvim](https://github.com/mason-org/mason.nvim)

---

**Last Updated**: July 2026
**LazyVim Version**: Latest (auto-updated)
**Neovim Version**: 0.9+ required
