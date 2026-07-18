# 💤 LazyVim Configuration

A modernized, cross-platform Neovim configuration based on [LazyVim](https://github.com/LazyVim/LazyVim).

## 🚀 Quick Start

**First time setup (recommended):**
```powershell
# Windows
.\scripts\setup.ps1

# Linux/macOS
./scripts/setup.sh
```

This runs cleanup + bootstrap to ensure a smooth installation.

**Already set up?** → See [CONFIGURATION_GUIDE.md](CONFIGURATION_GUIDE.md)

**Troubleshooting?** → See [scripts/README.md](scripts/README.md)

**Windows compiler setup?** → See [WINDOWS_COMPILER_SETUP.md](WINDOWS_COMPILER_SETUP.md)

## ✨ Features

- 🌍 **Cross-platform** - Works on Windows, macOS, and Linux
- 🎨 **VSCode Integration** - Seamless VSCode Neovim extension support
- 🛠️ **15+ LSP servers** pre-configured
- 🐛 **DAP debugging** with F5-F12 keybindings
- 🤖 **GitHub Copilot** integration
- 📦 **Auto-installing** plugins and LSP servers
- ⚡ **Fast** with lazy loading

## 📋 Prerequisites

- **Neovim** 0.9+
- **C compiler** (for Treesitter):
  - Windows: `winget install LLVM.LLVM`
  - macOS: `xcode-select --install`
  - Linux: Usually pre-installed (gcc or clang)

## 🎯 Quick Setup

**New installation:**
1. Install prerequisites (Neovim 0.9+, Git, C compiler)
2. Clone this config to your Neovim directory
3. Run the bootstrap script (see Quick Start above)
4. Launch Neovim!

**Manual setup:**
1. Install a C compiler (see Prerequisites)
2. Launch Neovim: `nvim`
3. Let plugins install automatically
4. Run `:TSUpdate` to compile parsers
5. Optional: Install formatters via `:Mason`

## 📚 Documentation

**Start here:** **[📖 Complete User Guide](docs/NEOVIM_USER_GUIDE.md)** - All keybindings, plugins, and workflows

**Specialized guides:**
- **[🎯 VSCode Integration](docs/VSCODE_INTEGRATION.md)** - Hybrid Mode: Use Neovim in VSCode
- **[🤖 Copilot Quick Reference](docs/COPILOT_QUICKREF.md)** - Accept suggestions, navigate alternatives, troubleshooting
- **[💻 PowerShell Development](docs/POWERSHELL_DEVELOPMENT.md)** - PowerShell IDE features and keybindings
- **[📋 Clipboard & Mouse Guide](docs/CLIPBOARD_MOUSE_GUIDE.md)** - Clipboard & mouse integration
- **[🔧 Configuration Review](docs/CONFIGURATION_REVIEW.md)** - Recent optimizations summary
- **[🧹 Maintenance Scripts](scripts/README.md)** - Bootstrap, cleanup, and setup scripts
- **[🌐 LazyVim Documentation](https://lazyvim.github.io/)** - Official LazyVim docs

## 🧹 Maintenance

Having plugin issues? Use the cleanup script:

**Windows:**
```powershell
.\scripts\cleanup.ps1
```

**Linux/macOS:**
```bash
./scripts/cleanup.sh
```

See [scripts/README.md](scripts/README.md) for details.

---

## 🎓 Learning Resources

- **[Complete User Guide](docs/NEOVIM_USER_GUIDE.md)** - Your main reference for all features
- **[LazyVim Keymaps](https://www.lazyvim.org/keymaps)** - Default LazyVim keybindings
- **[Neovim Documentation](https://neovim.io/doc/)** - Official Neovim docs
- Type `:help` in Neovim for built-in documentation


