# Installing Clang Compiler on Windows

Neovim Treesitter requires a C compiler to build syntax parsers. Your configuration is now set to prefer **clang** over gcc.

## Installation Options

### Option 1: Install LLVM/Clang (Recommended)

1. **Download LLVM**: Visit https://github.com/llvm/llvm-project/releases
2. **Download the Windows installer**: Look for `LLVM-<version>-win64.exe`
3. **Run the installer** and make sure to select "Add LLVM to system PATH"
4. **Verify installation**:
   ```powershell
   clang --version
   ```

### Option 2: Install via Scoop (Package Manager)

```powershell
# Install Scoop if not already installed
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

# Install LLVM
scoop install llvm
```

### Option 3: Install via Chocolatey

```powershell
choco install llvm
```

### Option 4: Install via Winget

```powershell
winget install LLVM.LLVM
```

## After Installation

1. **Restart Neovim** (or restart your terminal)
2. **Update Treesitter parsers**:
   ```vim
   :TSUpdate
   ```
3. **Check health**:
   ```vim
   :checkhealth nvim-treesitter
   ```

## Alternative: Use Visual Studio Build Tools

If you prefer Microsoft's compiler or already have Visual Studio:

1. Install **Visual Studio Build Tools** or **Visual Studio Community**
2. During installation, select "Desktop development with C++"
3. Restart Neovim
4. Treesitter will automatically use the MSVC compiler

## Troubleshooting

### Clang not found after installation
- Make sure LLVM is in your PATH
- Restart your terminal/PowerShell
- Check with: `where.exe clang` or `Get-Command clang`

### Treesitter still failing
Run this in Neovim to see detailed info:
```vim
:checkhealth nvim-treesitter
```

### Manual compiler specification
If you have clang in a non-standard location, you can set it explicitly in your PowerShell profile:
```powershell
$env:CC = "C:\path\to\clang.exe"
```

## Current Configuration

Your treesitter config ([lua/plugins/treesitter.lua](lua/plugins/treesitter.lua)) is set to try compilers in this order:
1. **clang** (preferred)
2. gcc (fallback)
3. zig (fallback)

This means if clang is available, it will be used automatically!
