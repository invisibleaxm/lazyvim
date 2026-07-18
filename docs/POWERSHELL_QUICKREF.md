# PowerShell in Neovim - Quick Reference

## 🚀 PowerShell Keymaps

| Key | Action |
|-----|--------|
| `<leader>pr` | Run current script |
| `<leader>pt` | Run Pester tests |
| `<leader>pa` | Analyze with PSScriptAnalyzer |
| `<leader>pf` | Format file (OTBS) |
| `<leader>pp` | Toggle PowerShell terminal |
| `<leader>ph` | Get-Help prompt |
| `<F9>` | Send line/selection to terminal |

## 💡 Completion

| Key | Action |
|-----|--------|
| `Ctrl+Space` | **Trigger completions** (PowerShell files) |
| `Tab` | Next item / expand snippet |
| `Shift+Tab` | Previous item |
| `Enter` | Confirm (only if selected) |
| `Ctrl+e` | Close menu |

**Note:** PowerShell completions are **NOT automatic** - use `Ctrl+Space`!

## 📝 Snippets

Type and press `Tab`:

- `func` → Function template
- `param` → Parameter with attributes
- `try` → Try-catch block
- `foreach` → Foreach loop
- `help` → Help comment block

## 🔍 LSP Navigation

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Show documentation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `<leader>ss` | Document symbols |

## 🐛 Debugging (DAP)

| Key | Action |
|-----|--------|
| `F5` | Start/Continue |
| `F8` | Toggle breakpoint |
| `F10` | Step over |
| `F11` | Step into |
| `F12` | Step out |

## 🎯 Quick Workflow

1. **Write** - Use snippets (`func<Tab>`, `help<Tab>`)
2. **Format** - `<leader>pf`
3. **Analyze** - `<leader>pa`
4. **Test** - `<leader>pt`
5. **Run** - `<leader>pr` or `<leader>pp`

## 🔧 Settings

**Less aggressive completion:**
- PowerShell: Manual trigger only (`Ctrl+Space`)
- Other files: Shows after typing, `Enter` needs selection

**Formatting:**
- Style: One True Brace Style (OTBS)
- Auto-expands aliases to full cmdlets
- Proper PascalCase

**Linting:**
- PSScriptAnalyzer integrated
- Real-time warnings/errors
- Best practice enforcement

## 📖 Full Guide

See [POWERSHELL_DEVELOPMENT.md](POWERSHELL_DEVELOPMENT.md) for complete documentation.
