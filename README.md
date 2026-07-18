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

For detailed documentation, refer to:
- [LazyVim Documentation](https://lazyvim.github.io/installation)
- [This config's guide](CONFIGURATION_GUIDE.md)

