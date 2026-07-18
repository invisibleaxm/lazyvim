# 📚 Neovim User Guide

**Complete guide to using your LazyVim configuration with all plugins, keybindings, and workflows.**

---

## 📖 Table of Contents

1. [Getting Started](#getting-started)
2. [Core Keybindings](#core-keybindings)
3. [Essential Plugins](#essential-plugins)
4. [PowerShell Development](#powershell-development)
5. [Debugging (DAP)](#debugging-dap)
6. [Git Integration](#git-integration)
7. [Tips & Workflows](#tips--workflows)

---

## 🚀 Getting Started

### First Launch

After installation, Neovim will automatically:
- Install all plugins via Lazy.nvim
- Set up LSP servers via Mason
- Compile Treesitter parsers
- Configure Copilot (requires GitHub authentication)

### Leader Key

Your **leader key** is `<Space>`. Press `<Space>` to trigger leader commands.

Example: `<leader>ff` means press `Space`, then `f`, then `f` to find files.

### Getting Help

- Press `<Space>?` - Show all keybindings
- Press `<Space>sk` - Search keymaps interactively
- Type `:Lazy` - Open plugin manager
- Type `:Mason` - Open LSP/tool installer
- Type `:checkhealth` - Diagnose issues

---

## ⌨️ Core Keybindings

### Navigation & Movement

| Key | Mode | Action |
|-----|------|--------|
| `<C-d>` | Normal | Scroll down (cursor stays centered) |
| `<C-u>` | Normal | Scroll up (cursor stays centered) |
| `n` | Normal | Next search result (centered) |
| `N` | Normal | Previous search result (centered) |
| `J` | Normal | Join lines (cursor stays in place) |

### File Operations

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ff` | Normal | Find files (Telescope) |
| `<leader>fg` | Normal | Live grep (search in files) |
| `<leader>fb` | Normal | Find buffers |
| `<leader>fr` | Normal | Recent files |
| `<leader>w` | Normal | Save file |
| `<leader>W` | Normal | Save all files |
| `<leader>q` | Normal | Quit window |
| `<leader>Q` | Normal | Quit all |

### Clipboard Operations

| Key | Mode | Action |
|-----|------|--------|
| `<leader>y` | Normal/Visual | Yank to system clipboard |
| `<leader>Y` | Normal | Yank line to system clipboard |
| `<leader>p` | Visual | Paste without yanking (keeps register) |
| `<leader>d` | Normal/Visual | Delete without yanking (black hole register) |

💡 **Tip:** Mouse selections automatically copy to clipboard!

### Editing

| Key | Mode | Action |
|-----|------|--------|
| `<CR>` | Normal | Change word under cursor |
| `YY` | Normal | Copy entire code block (`{}`) |
| `<A-F>` | Normal | Format file with LSP (like VSCode `Alt+Shift+F`) |
| `gcc` | Normal | Toggle line comment |
| `gc` | Visual | Toggle comment on selection |

### Code Navigation

| Key | Mode | Action |
|-----|------|--------|
| `gd` | Normal | Go to definition |
| `gr` | Normal | Go to references |
| `gi` | Normal | Go to implementation |
| `gy` | Normal | Go to type definition |
| `K` | Normal | Show hover documentation |
| `<leader>ca` | Normal | Code actions |
| `<leader>cr` | Normal | Rename symbol |
| `[d` | Normal | Previous diagnostic |
| `]d` | Normal | Next diagnostic |

### LSP & Diagnostics

| Key | Mode | Action |
|-----|------|--------|
| `<leader>cd` | Normal | Line diagnostics |
| `<leader>cl` | Normal | LSP info |
| `<leader>xx` | Normal | Trouble: Document diagnostics |
| `<leader>xX` | Normal | Trouble: Workspace diagnostics |
| `<leader>xq` | Normal | Trouble: Quickfix list |

---

## 🔌 Essential Plugins

### Telescope (Fuzzy Finder)

**Find anything in your project:**

| Keymap | Description |
|--------|-------------|
| `<leader>ff` | Find files by name |
| `<leader>fg` | Live grep (search text in files) |
| `<leader>fb` | Find open buffers |
| `<leader>fh` | Find help tags |
| `<leader>fr` | Recent files |
| `<leader>fo` | Find old files |
| `<leader>fc` | Find commands |
| `<leader>fk` | Find keymaps |

**Inside Telescope:**
- `<C-j>` / `<C-k>` - Navigate up/down
- `<C-n>` / `<C-p>` - Next/previous
- `<CR>` - Open file
- `<C-x>` - Open in horizontal split
- `<C-v>` - Open in vertical split
- `<Esc>` - Close Telescope

### Neo-tree (File Explorer)

| Keymap | Description |
|--------|-------------|
| `<leader>e` | Toggle file explorer (focus) |
| `<leader>E` | Toggle file explorer (no focus) |

**Inside Neo-tree:**
- `<Space>` - Toggle node
- `a` - Add file/folder
- `d` - Delete
- `r` - Rename
- `c` - Copy
- `x` - Cut
- `p` - Paste
- `y` - Copy filename
- `Y` - Copy relative path
- `gy` - Copy absolute path
- `R` - Refresh
- `?` - Show help

### GitHub Copilot

**Inline AI suggestions** appear as gray ghost text while typing.

#### Quick Reference

| Keymap | Mode | Action |
|--------|------|--------|
| `<Tab>` | Insert | Accept full Copilot suggestion |
| `<C-j>` | Insert | Accept full suggestion (alternative) |
| `<C-Right>` | Insert | Accept next word only |
| `<C-l>` | Insert | Accept line only |
| `<Alt-]>` | Insert | Next Copilot suggestion |
| `<Alt-[>` | Insert | Previous Copilot suggestion |
| `<C-]>` | Insert | Dismiss Copilot suggestion |
| `<Alt-Enter>` | Insert | Open Copilot panel (all suggestions) |
| `<leader>co` | Normal | Toggle Copilot on/off |

**📖 Complete Copilot Guide:** [COPILOT_QUICKREF.md](COPILOT_QUICKREF.md)

#### How it works:
1. Type code naturally
2. Copilot shows gray ghost text suggestions
3. **Press `<Tab>` or `<C-j>` to accept** (most common)
4. **Press `<C-Right>` to accept word-by-word** (partial accept)
5. Press `<Alt-]>` to see alternative suggestions
6. Keep typing to ignore

#### Common Issue: Can't Accept Suggestion?

**Problem:** Completion menu is open (takes priority over Copilot).

**Solution:**
- Use `<C-j>` instead of `<Tab>` (dedicated Copilot accept)
- Or press `<C-e>` to close menu, then `<Tab>`

**First time setup:**
```
:Copilot auth
```

### Completion (nvim-cmp)

**Smart autocompletion while typing:**

**Source priority:**
1. **LSP** - Language server keywords (highest priority)
2. **Copilot** - AI suggestions
3. **Snippets** - Code templates
4. **Buffer** - Words from open files (4+ characters)
5. **Path** - File paths (3+ characters)

| Keymap | Mode | Action |
|--------|------|--------|
| `<Tab>` | Insert | Accept completion / Next item |
| `<S-Tab>` | Insert | Previous completion item |
| `<CR>` | Insert | Confirm (only if explicitly selected) |
| `<C-Space>` | Insert | Trigger completion manually |
| `<C-e>` | Insert | Close completion menu |

💡 **Non-aggressive:** Completions won't auto-insert, you must select them!

### Trouble (Diagnostics Panel)

**Better error/warning list:**

| Keymap | Description |
|--------|-------------|
| `<leader>xx` | Document diagnostics |
| `<leader>xX` | Workspace diagnostics |
| `<leader>xL` | Location list |
| `<leader>xQ` | Quickfix list |

### Notifications (Noice + Notify)

**Notification center:**

| Keymap | Description |
|--------|-------------|
| `<leader>un` | Dismiss all notifications |
| `<leader>nh` | Notification history |
| `<leader>sn` | Search notifications |

---

## 💻 PowerShell Development

**Dedicated section for PowerShell scripting.**

### Quick Reference

| Keymap | Description |
|--------|-------------|
| `<leader>pp` | Toggle PowerShell terminal (floating) |
| `<leader>pr` | Run current PowerShell script |
| `<leader>pt` | Run Pester tests |
| `<leader>pa` | Analyze script (PSScriptAnalyzer) |
| `<leader>ph` | Get PowerShell help |
| `<leader>pf` | Format PowerShell file |
| `<F9>` | Send current line to terminal |
| `<F9>` | Send visual selection to terminal (Visual mode) |

### Features

✅ **PowerShell Editor Services LSP** - IntelliSense, formatting, diagnostics
✅ **PSScriptAnalyzer** - Code analysis and best practices
✅ **Pester Testing** - Run tests with `<leader>pt`
✅ **Syntax Highlighting** - via Treesitter
✅ **Smart Completion** - LSP keywords appear first
✅ **Code Formatting** - OTBS (One True Brace Style)

### Workflow: Edit & Test

**Method 1: Quick Run**
1. Edit your `.ps1` file
2. Press `<leader>pr` to run entire script
3. View output in terminal

**Method 2: Interactive Testing**
1. Edit your `.ps1` file
2. Press `<leader>pp` to open PowerShell terminal (floating)
3. Select code you want to test (Visual mode)
4. Press `<F9>` to send to terminal
5. See results immediately
6. Close terminal with `<leader>pp` again

**Method 3: Pester Tests**
1. Write Pester tests in `.Tests.ps1` file
2. Press `<leader>pt` to run tests
3. View test results

### Code Formatting

Your PowerShell files use **OTBS formatting**:
- Opening brace on same line
- Proper indentation
- Correct cmdlet casing
- Aliases expanded

**Format file:** `<leader>pf`

**Auto-format on save:** Already enabled!

### PowerShell Snippets

Type these abbreviations and press `<Tab>`:

| Trigger | Expands To |
|---------|------------|
| `func` | Function template |
| `param` | Parameter block |
| `try` | Try-catch-finally |
| `foreach` | ForEach-Object loop |
| `help` | Comment-based help |

### PowerShell Completion Behavior

**Smart completion tuning for PowerShell files:**
- LSP keywords (like `function`, `param`) appear **first**
- Copilot suggestions **second**
- Snippets **third**
- Buffer completions require **5+ characters** (reduces noise)
- Path completions **disabled** (prevents `func.exe` appearing before `function`)

💡 **Typing `fu` shows:** `function` keyword (LSP), not `func.exe` (path)!

### Terminal Integration

| Keymap | Description |
|--------|-------------|
| `<leader>pp` | PowerShell terminal (floating window) |
| `<C-\>` | General terminal (horizontal split) |
| `<F9>` | Send code to terminal |

**PowerShell terminal** is pre-configured with `pwsh -NoLogo` for clean output.

### Troubleshooting PowerShell LSP

**LSP not working?**
```
:Mason
```
Install `powershell-editor-services`

**Formatting not working?**
```
:LspInfo
```
Check if `powershell_es` is attached

**Code analysis not running?**
Install PSScriptAnalyzer:
```powershell
Install-Module PSScriptAnalyzer -Scope CurrentUser
```

### PowerShell Best Practices

Your LSP is configured to enforce:
- ✅ Use full cmdlet names (no aliases)
- ✅ Proper PascalCase for cmdlets
- ✅ Consistent brace style (OTBS)
- ✅ No semicolons as line terminators
- ✅ Whitespace around operators

See full guide: [POWERSHELL_DEVELOPMENT.md](POWERSHELL_DEVELOPMENT.md)

---

## 🐛 Debugging (DAP)

**Debug Adapter Protocol** - Visual Studio-style debugging.

### Debug Keybindings

| Key | Action |
|-----|--------|
| `<F5>` | Start/Continue debugging |
| `<Shift-F5>` | Stop debugging |
| `<F8>` | Toggle breakpoint |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>dh` | Hover variables |
| `<leader>dP` | Preview variables |

### Workflow

1. Open file you want to debug
2. Press `<F8>` on line to set breakpoint (red dot appears)
3. Press `<F5>` to start debugging
4. Use `<F10>` to step through code
5. Press `<Shift-F5>` to stop

💡 **Supported languages:** Depends on installed debug adapters (install via Mason).

---

## 🔀 Git Integration

### LazyGit (Best Way)

| Keymap | Description |
|--------|-------------|
| `<leader>gg` | Open LazyGit (full-screen terminal UI) |
| `<leader>gf` | LazyGit current file history |
| `<leader>gl` | LazyGit log |

**Inside LazyGit:**
- `1-5` - Switch panels (Status, Files, Branches, Commits, Stash)
- `<Space>` - Stage/unstage file
- `c` - Commit
- `P` - Push
- `p` - Pull
- `?` - Show help
- `q` - Quit

### Gitsigns (In-buffer Git)

| Keymap | Description |
|--------|-------------|
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghp` | Preview hunk |
| `<leader>ghb` | Blame line |
| `[h` | Previous hunk |
| `]h` | Next hunk |

---

## 💡 Tips & Workflows

### Multi-File Editing

1. **Find files:** `<leader>ff`
2. **Select multiple:** `<Tab>` in Telescope to mark files
3. **Open all:** `<CR>` to open in tabs
4. **Switch buffers:** `<leader>fb` or `<leader>,`

### Search & Replace Across Project

1. **Search:** `<leader>fg` (live grep)
2. **Send to quickfix:** `<C-q>` in Telescope
3. **Open quickfix:** `<leader>xq`
4. **Replace:** `:cdo s/old/new/g | update`

### PowerShell Script Development

1. **Open script:** `nvim script.ps1`
2. **LSP auto-formats** on save
3. **Test interactively:**
   - `<leader>pp` (open terminal)
   - Select code, `<F9>` (send to terminal)
4. **Run full script:** `<leader>pr`
5. **Check for issues:** `<leader>pa` (PSScriptAnalyzer)

### Working with Multiple Terminals

1. **PowerShell:** `<leader>pp` (floating)
2. **General:** `<C-\>` (horizontal split)
3. **Send code to active terminal:** `<F9>`

**Terminal mode shortcuts:**
- `<C-\><C-n>` - Exit terminal mode (back to Normal mode)
- `i` or `a` - Enter terminal mode

### Maximizing Productivity

**Learn these first:**
1. `<leader>ff` - Find files (most used!)
2. `<leader>fg` - Search in files
3. `<leader>e` - File explorer
4. `<leader>pp` - PowerShell terminal
5. `<F9>` - Send code to terminal
6. `<leader>pf` - Format file

**VSCode Users:**
- `<C-p>` still works (opens Telescope file finder)
- `<A-F>` formats (like `Alt+Shift+F`)
- Mouse works! (click, select, scroll)
- Clipboard integration automatic

### Customization

**Add your own keybindings:**
Edit `lua/config/keymaps.lua`

**Add your own plugins:**
Create files in `lua/plugins/` directory

**Change LSP settings:**
Edit respective plugin files in `lua/plugins/`

**Format on save:**
Already enabled for PowerShell and most languages!

---

## 📚 Additional Resources

- **Configuration Review:** [CONFIGURATION_REVIEW.md](CONFIGURATION_REVIEW.md)
- **PowerShell Guide:** [POWERSHELL_DEVELOPMENT.md](POWERSHELL_DEVELOPMENT.md)
- **PowerShell Quick Reference:** [POWERSHELL_QUICKREF.md](POWERSHELL_QUICKREF.md)
- **Clipboard & Mouse:** [CLIPBOARD_MOUSE_GUIDE.md](CLIPBOARD_MOUSE_GUIDE.md)
- **Maintenance Scripts:** [scripts/README.md](../scripts/README.md)
- **LazyVim Docs:** https://lazyvim.github.io
- **Neovim Docs:** `:help`

---

## 🆘 Quick Help

**Lost?** → Press `<Space>?` to show all keybindings

**Plugin issues?** → `:Lazy` → `X` (check for errors)

**LSP not working?** → `:LspInfo` → `:Mason` (install servers)

**Performance issues?** → `:Lazy profile` (check slow plugins)

**Need help?** → `:checkhealth` (diagnose issues)

---

**Happy coding!** 🚀
