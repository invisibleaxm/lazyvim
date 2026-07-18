# Neovim Maintenance Scripts

This directory contains cross-platform maintenance scripts for your Neovim configuration.

## 🎯 Quick Reference

| Script | Purpose | When to Use |
|--------|---------|-------------|
| `setup` | **Complete fresh setup** | First install, new machine |
| `bootstrap` | **Initial installation** | First time only, or with `-Force` |
| `cleanup` | **Fix existing install** | Corrupted plugins, sync issues |

## setup script (Recommended)

**All-in-one** - Combines cleanup + bootstrap for foolproof fresh installations.

### Usage

**Windows:**
```powershell
.\scripts\setup.ps1
```

**Linux/macOS:**
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

This runs:
1. Cleanup (removes corrupted files)
2. Bootstrap (installs everything)

Perfect for first-time setup!

## bootstrap script

**First-time setup** - Performs complete headless installation of plugins, Treesitter parsers, and Mason tools.

### Usage

**Windows (PowerShell):**
```powershell
# First time setup
.\scripts\bootstrap.ps1

# Force reinstall everything
.\scripts\bootstrap.ps1 -Force

# Show detailed output
.\scripts\bootstrap.ps1 -Verbose
```

**Linux/macOS (Bash):**
```bash
# Make executable (first time only)
chmod +x scripts/bootstrap.sh

# First time setup
./scripts/bootstrap.sh

# Force reinstall everything
./scripts/bootstrap.sh --force

# Show detailed output
./scripts/bootstrap.sh --verbose
```

### What it does

1. **Checks prerequisites** - Verifies Neovim, Git, C compiler are installed
2. **Cleans environment** - Removes lock files and optionally existing plugins
3. **Installs plugins** - Runs headless `Lazy! sync` to install all ~60 plugins
4. **Compiles parsers** - Runs `TSUpdateSync` to compile Treesitter parsers
5. **Installs Mason tools** - Queues LSP servers, formatters, and linters
6. **Verifies installation** - Checks everything installed correctly
7. **Creates marker** - Marks successful bootstrap to avoid re-running

### When to use

- **First time setup** after cloning this config
- After major Neovim version upgrades
- When starting fresh on a new machine
- When plugins fail to install on first launch
- Use `-Force` / `--force` to completely reinstall everything

### Options

| Option | Description |
|--------|-------------|
| `-Force` / `--force` | Remove all plugins and reinstall from scratch |
| `-Verbose` / `--verbose` | Show detailed output from plugin installations |

## cleanup script

Cleans corrupted plugins, resets local changes, and syncs all plugins.

### Usage

**Windows (PowerShell):**
```powershell
# Basic cleanup and sync
.\scripts\cleanup.ps1

# Full clean (removes all plugins, forces reinstall)
.\scripts\cleanup.ps1 -FullClean

# Cleanup only, skip sync
.\scripts\cleanup.ps1 -SkipSync
```

**Linux/macOS (Bash):**
```bash
# Make executable (first time only)
chmod +x scripts/cleanup.sh

# Basic cleanup and sync
./scripts/cleanup.sh

# Full clean (removes all plugins, forces reinstall)
./scripts/cleanup.sh --full-clean

# Cleanup only, skip sync
./scripts/cleanup.sh --skip-sync
```

### What it does

1. **Removes lock file** - Clears `lazy-lock.json` for fresh state
2. **Cleans corrupted parsers** - Removes `.so2` backup files that cause errors
3. **Removes temp directories** - Clears `.cloning` directories from failed installations
4. **Resets plugin changes** - Runs `git reset --hard HEAD` on plugins with local modifications
5. **Syncs plugins** - Runs headless `Lazy! sync` to update all plugins
6. **Reports summary** - Shows plugin count and parser count

### When to use

- After telescope/plugin installation failures
- When seeing "local changes" blocking updates
- After corrupted parser errors (`.so2` files)
- Before major Neovim/plugin updates
- When plugins won't sync properly

### Options

| Option | Description |
|--------|-------------|
| `-FullClean` / `--full-clean` | Removes entire `lazy` directory, forces complete reinstall |
| `-SkipSync` / `--skip-sync` | Only performs cleanup, skips the sync step |

## Adding to PATH

To run from anywhere, add the scripts directory to your system PATH or create an alias:

**PowerShell profile** (`$PROFILE`):
```powershell
function nvim-cleanup { & "$env:LOCALAPPDATA\nvim\scripts\cleanup.ps1" @args }
```

**Bash/Zsh** (`~/.bashrc` or `~/.zshrc`):
```bash
alias nvim-cleanup="$HOME/.config/nvim/scripts/cleanup.sh"
```

Then simply run:
```bash
nvim-cleanup
nvim-cleanup --full-clean
```
