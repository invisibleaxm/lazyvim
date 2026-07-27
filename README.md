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

**Want to know what's actually installed?** → See the [Plugin Guide](CONFIGURATION_GUIDE.md)

**Troubleshooting?** → See [scripts/README.md](scripts/README.md)

## ✨ Features

- 🌍 **Cross-platform** - Works on Windows, macOS, and Linux
- 🎨 **VSCode Integration** - Seamless VSCode Neovim extension support
- 🛠️ **LSP servers** pre-configured for Python, Rust, Lua, YAML, Bash, Docker, Markdown, Ansible, Azure Pipelines, and PowerShell
- 🤖 **GitHub Copilot** integration
- 📦 **Auto-installing** plugins and LSP servers (via Mason)
- ⚡ **Fast** with lazy loading

## 📋 Prerequisites

- **Neovim** 0.9+
- **A C compiler** (for Treesitter parsers) — `gcc` is preferred and auto-detected (e.g. via MSYS2/MinGW on Windows), with `clang` used automatically as a fallback if `gcc` isn't found. Just make sure one of the two is on your `PATH`.

## 🎯 Quick Setup

**New installation:**

1. Install prerequisites (Neovim 0.9+, Git, a C compiler)
2. Clone this config to your Neovim directory
3. Run the bootstrap script (see Quick Start above)
4. Launch Neovim!

**Manual setup:**

1. Install a C compiler (see Prerequisites)
2. Launch Neovim: `nvim`
3. Let plugins install automatically
4. Run `:TSUpdate` to compile parsers
5. Optional: Install formatters/linters via `:Mason`

## 📚 Documentation

**Start here:** **[🔌 Plugin Guide](CONFIGURATION_GUIDE.md)** - What's installed, what it does, and how to use it (cheat sheets + links to official docs)

**Complete reference:** **[📖 Complete User Guide](docs/NEOVIM_USER_GUIDE.md)** - All keybindings, plugins, and workflows

**Specialized guides:**

- **[🎯 VSCode Integration](docs/VSCODE_INTEGRATION.md)** - Hybrid Mode: Use Neovim in VSCode
- **[🤖 Copilot Quick Reference](docs/COPILOT_QUICKREF.md)** - Accept suggestions, navigate alternatives, troubleshooting
- **[💻 PowerShell Development](docs/POWERSHELL_DEVELOPMENT.md)** - PowerShell IDE features and keybindings
- **[📋 Clipboard & Mouse Guide](docs/CLIPBOARD_MOUSE_GUIDE.md)** - Clipboard & mouse integration
- **[🧹 Maintenance Scripts](scripts/README.md)** - Bootstrap, cleanup, and setup scripts
- **[📝 Changelog](CHANGELOG.md)** - Recent changes and improvements
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
