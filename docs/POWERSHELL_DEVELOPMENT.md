# PowerShell Development in Neovim

Comprehensive guide for using Neovim as a PowerShell IDE with optimized completion, LSP, and tooling.

## 🚀 Features

✅ **PowerShell Editor Services LSP** - Full IntelliSense, go-to-definition, find references
✅ **Less Aggressive Completion** - Manual trigger with `Ctrl+Space`, Enter only confirms selected items
✅ **PSScriptAnalyzer Integration** - Real-time linting and best practice warnings
✅ **Syntax Highlighting** - Treesitter-powered syntax highlighting
✅ **Code Formatting** - One True Brace Style (OTBS) formatting
✅ **Snippets** - Common PowerShell patterns (function, param, try/catch, foreach, help blocks)
✅ **Integrated Terminal** - Run scripts directly from Neovim
✅ **Pester Testing** - Quick test execution

## 📦 Installation

All tools are automatically installed via Mason:

```vim
:Mason
```

Look for:
- ✅ `powershell-editor-services` - LSP server

**External tools** (optional but recommended):
```powershell
# Install PSScriptAnalyzer for linting
Install-Module -Name PSScriptAnalyzer -Force

# Install Pester for testing
Install-Module -Name Pester -Force -SkipPublisherCheck
```

## ⌨️ Keymaps

### PowerShell-Specific

| Keymap | Mode | Action | Description |
|--------|------|--------|-------------|
| `<leader>pr` | Normal | Run script | Execute current PowerShell file |
| `<leader>pt` | Normal | Run Pester tests | Run Invoke-Pester in current directory |
| `<leader>pa` | Normal | Analyze script | Run PSScriptAnalyzer on current file |
| `<leader>ph` | Normal | Get help | Open PowerShell Get-Help prompt |
| `<leader>pf` | Normal | Format file | Format with LSP (OTBS style) |
| `<leader>pp` | Normal | PowerShell terminal | Toggle floating PowerShell terminal |

### Completion

| Keymap | Mode | Action |
|--------|------|--------|
| `<C-Space>` | Insert | Manually trigger completion |
| `<Tab>` | Insert | Next completion item / expand snippet |
| `<S-Tab>` | Insert | Previous completion item |
| `<CR>` | Insert | Confirm **only if item selected** (not aggressive) |
| `<C-e>` | Insert | Close completion menu |

### LSP (Work in any file with LSP)

| Keymap | Action |
|--------|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Show hover documentation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |

## 📝 Snippets

Type these and press `Tab` to expand:

| Trigger | Expands To |
|---------|------------|
| `func` | Function template with param block |
| `param` | Parameter with attributes |
| `try` | Try-catch block with error handling |
| `foreach` | Foreach loop |
| `help` | Comment-based help block (Synopsis, Description, Examples) |

### Example: Function Snippet

Type `func<Tab>`:

```powershell
function FunctionName {
    param(

    )


}
```

### Example: Help Block

Type `help<Tab>`:

```powershell
<#
.SYNOPSIS
    Brief description
.DESCRIPTION
    Detailed description
.PARAMETER ParameterName
    Parameter description
.EXAMPLE
    Example usage
#>
```

## 🔧 LSP Features

### Code Formatting

**Automatic formatting on save** (configured in powershell.lua):
- One True Brace Style (OTBS)
- Proper PascalCase for cmdlets
- Expand aliases to full cmdlet names
- Consistent spacing around operators, pipes, braces

**Manual format:**
```vim
<leader>pf
```

### Script Analysis

PowerShell Editor Services integrates with PSScriptAnalyzer to show:
- ⚠️ **Warnings** - Best practice violations
- ❌ **Errors** - Syntax errors and serious issues
- ℹ️ **Information** - Suggestions for improvement

**Rules enforced:**
- No aliases in scripts
- Proper cmdlet naming conventions
- Security best practices
- Performance optimizations

**Manual analysis:**
```vim
<leader>pa
```

### IntelliSense

**Automatic completion** for:
- PowerShell cmdlets (Get-Process, Set-Item, etc.)
- Module functions
- Variables
- Parameters with type hints
- File paths
- Command history

**Trigger completion manually:**
- `Ctrl+Space` - Show completions

### Hover Documentation

**See cmdlet help without leaving Neovim:**
```vim
" Position cursor on a cmdlet
K  " Shows Get-Help information
```

## 🎯 Completion Behavior

### General Files (Less Aggressive)

- ✅ Completions appear after typing
- ✅ **Enter** = New line (NOT auto-complete first item)
- ✅ **Tab** = Select next item
- ✅ Must explicitly select an item to confirm with Enter
- ✅ `Ctrl+Space` to manually trigger

### PowerShell Files (Even Less Aggressive)

In `.ps1`, `.psm1`, `.psd1` files:
- ✅ Completions **only show when explicitly triggered** with `Ctrl+Space`
- ✅ Limited to 20 LSP suggestions at a time
- ✅ No automatic popup on typing (prevents aggressive suggestions like in your screenshot)

**This prevents the overwhelming completion popup you were seeing!**

## 🧪 Testing with Pester

### Run Tests

```vim
<leader>pt  " Run all Pester tests in current directory
```

### Example Test File

Create a file like `MyModule.Tests.ps1`:

```powershell
Describe 'MyFunction' {
    It 'Should return expected value' {
        $result = MyFunction -Param "test"
        $result | Should -Be "expected"
    }
}
```

## 🐛 Debugging

### Using F5-F12 Debugger

PowerShell debugging with DAP (Debug Adapter Protocol):

```vim
<F5>  " Start/Continue debugging
<F8>  " Toggle breakpoint
<F10> " Step over
<F11> " Step into
<F12> " Step out
```

**Set up debugging** in your script:
1. Place breakpoints with `<F8>`
2. Start debugging with `<F5>`
3. Use `:DapContinue`, `:DapStepOver`, etc.

## 📁 File Structure

### Recommended PowerShell Project Structure

```
MyModule/
├── MyModule.psm1           # Module file
├── MyModule.psd1           # Module manifest
├── Public/                 # Public functions
│   └── Get-Something.ps1
├── Private/                # Private helper functions
│   └── Format-Helper.ps1
├── Tests/                  # Pester tests
│   └── MyModule.Tests.ps1
└── README.md
```

### Neovim PowerShell Config Files

```
nvim/
└── lua/
    └── plugins/
        ├── powershell.lua      # PowerShell-specific config (NEW!)
        ├── completion.lua      # Less aggressive completion
        ├── lsp.lua            # General LSP config
        └── treesitter.lua     # Syntax highlighting
```

## 🎨 Syntax Highlighting

**Treesitter PowerShell parser** provides:
- Accurate syntax highlighting
- Code folding
- Text objects
- Better indentation

**Check parser status:**
```vim
:TSInstall powershell
:TSUpdate powershell
```

## 🔍 Finding Functions

### Telescope Integration

```vim
<leader>ff  " Find files
<leader>fg  " Live grep (search in files)
<leader>fs  " Find string under cursor
```

**Search for PowerShell functions:**
```vim
<leader>fg function .*{
```

### Symbol Search

```vim
gd   " Go to definition
gr   " Find references
<leader>ss  " Search document symbols
```

## ⚙️ Configuration

### Customize PowerShell LSP

Edit [lua/plugins/powershell.lua](../lua/plugins/powershell.lua):

```lua
settings = {
  powershell = {
    codeFormatting = {
      preset = "OTBS",  -- or "Allman", "Stroustrup"
      -- ... more settings
    },
  },
}
```

### Customize Completion Behavior

Edit [lua/plugins/completion.lua](../lua/plugins/completion.lua):

```lua
-- Make even less aggressive
opts.completion.keyword_length = 3  -- Require 3 characters
```

### Add Custom Snippets

Edit [lua/plugins/powershell.lua](../lua/plugins/powershell.lua) in the LuaSnip section:

```lua
s("mysnippet", {
  t("Write-Host '"),
  i(1, "message"),
  t("'"),
}),
```

## 🚨 Troubleshooting

### Issue: LSP not starting

**Check LSP status:**
```vim
:LspInfo
```

**Ensure PowerShell Editor Services installed:**
```vim
:Mason
" Look for powershell-editor-services
```

**Check logs:**
```vim
:LspLog
```

### Issue: Completions too aggressive

**PowerShell files should use manual trigger** (configured in powershell.lua).

If still too aggressive, edit `lua/plugins/powershell.lua`:

```lua
cmp.setup.filetype({ "ps1", "psm1", "psd1" }, {
  completion = {
    autocomplete = false,  -- Only manual trigger
  },
})
```

### Issue: Formatting not working

**Install PowerShell Editor Services:**
```vim
:Mason
" Install powershell-editor-services
```

**Manually format:**
```vim
<leader>pf
" Or
:lua vim.lsp.buf.format()
```

### Issue: Syntax highlighting broken

**Install/update Treesitter parser:**
```vim
:TSInstall powershell
:TSUpdate powershell
```

**Check health:**
```vim
:checkhealth nvim-treesitter
```

## 📚 Resources

- [PowerShell Editor Services](https://github.com/PowerShell/PowerShellEditorServices)
- [PSScriptAnalyzer Rules](https://github.com/PowerShell/PSScriptAnalyzer)
- [Pester Documentation](https://pester.dev/)
- [Neovim LSP Config](https://github.com/neovim/nvim-lspconfig)

## 🎓 Tips & Tricks

### 1. Quick Script Execution

Run current script:
```vim
<leader>pr
```

Or use toggleterm:
```vim
<leader>pp  " Open PowerShell terminal
# Type your commands
```

### 2. Inline Script Execution

Send current line to terminal:
```vim
<F9>  " Send line to terminal
```

Send visual selection:
```vim
<visual selection>
<F9>  " Send selection to terminal
```

### 3. Quick Help Lookup

```vim
<leader>ph Get-Process<CR>
" Opens Get-Help Get-Process
```

Or hover over cmdlet:
```vim
K  " Shows inline help
```

### 4. Navigate Large Scripts

```vim
<leader>ss  " Document symbols (functions, variables)
gd          " Go to definition
Ctrl+o      " Jump back
```

### 5. Multi-File Editing

```vim
<leader>ff  " Find files
<leader>fg Write-Host  " Find all Write-Host calls
```

## 🎯 Workflow Example

### Writing a New Module

1. **Create file:**
   ```vim
   :e MyModule/Public/Get-User.ps1
   ```

2. **Write function using snippets:**
   ```vim
   help<Tab>  " Add help block
   func<Tab>  " Add function template
   ```

3. **Format code:**
   ```vim
   <leader>pf
   ```

4. **Check for issues:**
   ```vim
   <leader>pa  " PSScriptAnalyzer
   ```

5. **Run script:**
   ```vim
   <leader>pr
   ```

6. **Write tests:**
   ```vim
   :e MyModule/Tests/Get-User.Tests.ps1
   ```

7. **Run tests:**
   ```vim
   <leader>pt
   ```

## ✨ What Makes This Setup Great for PowerShell

✅ **Non-intrusive completion** - Doesn't get in your way
✅ **Professional formatting** - OTBS style, proper cmdlet casing
✅ **Real-time linting** - Catch issues before running
✅ **Fast** - LSP in Neovim is faster than VSCode PowerShell extension
✅ **Keyboard-driven** - No mouse needed
✅ **Integrated terminal** - Run scripts without leaving Neovim
✅ **Cross-platform** - Works on Windows, Linux, macOS

Your PowerShell development experience in Neovim is now **better than VSCode**! 🚀
