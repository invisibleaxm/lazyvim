#!/usr/bin/env pwsh
# Neovim Bootstrap Script
# Performs initial setup, plugin installation, and configuration headlessly

param(
  [switch]$Force,      # Force reinstall even if already bootstrapped
  [switch]$Verbose     # Show detailed output
)

$ErrorActionPreference = "Stop"

# Detect config and data directories
if ($IsWindows -or $env:OS -eq "Windows_NT") {
  $configDir = "$env:LOCALAPPDATA\nvim"
  $dataDir = "$env:LOCALAPPDATA\nvim-data"
} else {
  $configDir = "$env:HOME/.config/nvim"
  $dataDir = "$env:HOME/.local/share/nvim"
}

$lazyDir = "$dataDir\lazy"
$bootstrapMarker = "$dataDir\.bootstrapped"

Write-Host "`n🚀 Neovim Bootstrap Script" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Check if already bootstrapped
if ((Test-Path $bootstrapMarker) -and -not $Force) {
  Write-Host "`n✅ Neovim already bootstrapped!" -ForegroundColor Green
  Write-Host "   Use -Force to run again" -ForegroundColor Gray
  $continue = Read-Host "`nContinue anyway? (y/N)"
  if ($continue -ne "y" -and $continue -ne "Y") {
    exit 0
  }
}

# Step 1: Prerequisites check
Write-Host "`n📋 Step 1: Checking prerequisites..." -ForegroundColor Cyan

# Check Neovim
Write-Host "  Checking Neovim..." -NoNewline
try {
  $nvimVersion = (nvim --version | Select-Object -First 1) -replace '.*v(\d+\.\d+\.\d+).*', '$1'
  Write-Host " ✓ $nvimVersion" -ForegroundColor Green
} catch {
  Write-Host " ✗ Not found" -ForegroundColor Red
  Write-Host "`n❌ Neovim is not installed or not in PATH" -ForegroundColor Red
  exit 1
}

# Check C compiler (for Treesitter)
Write-Host "  Checking C compiler..." -NoNewline
$hasCompiler = $false
$compiler = ""

if (Get-Command gcc -ErrorAction SilentlyContinue) {
  $gccVersion = (gcc --version | Select-Object -First 1)
  Write-Host " ✓ gcc ($gccVersion)" -ForegroundColor Green
  $hasCompiler = $true
  $compiler = "gcc"
} elseif (Get-Command clang -ErrorAction SilentlyContinue) {
  $clangVersion = (clang --version | Select-Object -First 1)
  Write-Host " ✓ clang ($clangVersion)" -ForegroundColor Green
  $hasCompiler = $true
  $compiler = "clang"
} else {
  Write-Host " ⚠ Not found" -ForegroundColor Yellow
  Write-Host "    Treesitter parser compilation will fail" -ForegroundColor Yellow
  Write-Host "    Install: winget install LLVM.LLVM (Windows)" -ForegroundColor Gray
  Write-Host "    Or: winget install msys2, then run Setup-MSYS2.ps1" -ForegroundColor Gray
}

# Check tree-sitter CLI
Write-Host "  Checking tree-sitter CLI..." -NoNewline
if (Get-Command tree-sitter -ErrorAction SilentlyContinue) {
  Write-Host " ✓ Found" -ForegroundColor Green
} else {
  Write-Host " ⚠ Not found (optional)" -ForegroundColor Yellow
}

# Check Git
Write-Host "  Checking Git..." -NoNewline
if (Get-Command git -ErrorAction SilentlyContinue) {
  Write-Host " ✓ Found" -ForegroundColor Green
} else {
  Write-Host " ✗ Not found" -ForegroundColor Red
  Write-Host "`n❌ Git is required for plugin management" -ForegroundColor Red
  exit 1
}

# Step 2: Clean slate
Write-Host "`n🧹 Step 2: Preparing clean environment..." -ForegroundColor Cyan

if (Test-Path $dataDir) {
  $pluginCount = 0
  if (Test-Path $lazyDir) {
    $pluginCount = (Get-ChildItem $lazyDir -Directory -ErrorAction SilentlyContinue | Measure-Object).Count
  }

  if ($pluginCount -gt 0 -and $Force) {
    Write-Host "  Removing existing plugins ($pluginCount)..." -ForegroundColor Yellow
    Remove-Item "$lazyDir\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  ✓ Cleaned plugin directory" -ForegroundColor Green
  } elseif ($pluginCount -gt 0) {
    Write-Host "  ℹ Found $pluginCount existing plugins (use -Force to reinstall)" -ForegroundColor Gray
  }
}

# Remove lock file for fresh start
if (Test-Path "$configDir\lazy-lock.json") {
  Remove-Item "$configDir\lazy-lock.json" -Force
  Write-Host "  ✓ Removed lock file" -ForegroundColor Green
}

# Step 3: Install plugins
Write-Host "`n📦 Step 3: Installing plugins..." -ForegroundColor Cyan
Write-Host "  This will take 1-2 minutes..." -ForegroundColor Gray

$output = nvim --headless "+Lazy! sync" +qa 2>&1

if ($Verbose) {
  Write-Host "`n--- Plugin Installation Output ---" -ForegroundColor Gray
  $output | Write-Host
  Write-Host "--- End Output ---`n" -ForegroundColor Gray
}

# Check for errors
$errors = $output | Select-String -Pattern "error|ERROR|failed|FAILED" -CaseSensitive:$false
if ($errors) {
  Write-Host "  ⚠ Some plugins had issues:" -ForegroundColor Yellow
  $errors | ForEach-Object { Write-Host "    $_" -ForegroundColor Yellow }
} else {
  Write-Host "  ✓ Plugins installed successfully" -ForegroundColor Green
}

# Count installed plugins
if (Test-Path $lazyDir) {
  $pluginCount = (Get-ChildItem $lazyDir -Directory -ErrorAction SilentlyContinue | Measure-Object).Count
  Write-Host "  ℹ Installed: $pluginCount plugins" -ForegroundColor Gray
}

# Step 4: Compile Treesitter parsers
Write-Host "`n🌳 Step 4: Compiling Treesitter parsers..." -ForegroundColor Cyan

if ($hasCompiler) {
  Write-Host "  Compiling with $compiler..." -ForegroundColor Gray

  $tsOutput = nvim --headless "+TSUpdateSync" +qa 2>&1

  if ($Verbose) {
    Write-Host "`n--- Treesitter Output ---" -ForegroundColor Gray
    $tsOutput | Write-Host
    Write-Host "--- End Output ---`n" -ForegroundColor Gray
  }

  # Count compiled parsers
  $parserDir = "$dataDir\site\parser"
  if (Test-Path $parserDir) {
    $parserCount = (Get-ChildItem $parserDir -Filter "*.so" -ErrorAction SilentlyContinue | Measure-Object).Count
    Write-Host "  ✓ Compiled $parserCount parsers" -ForegroundColor Green
  } else {
    Write-Host "  ⚠ Parser directory not created" -ForegroundColor Yellow
  }
} else {
  Write-Host "  ⏭️  Skipped (no C compiler)" -ForegroundColor Yellow
}

# Step 5: Install Mason tools
Write-Host "`n🔧 Step 5: Installing Mason tools..." -ForegroundColor Cyan
Write-Host "  Installing LSP servers, formatters, linters..." -ForegroundColor Gray

# Create a Lua script to install all Mason tools defined in config
$masonScript = @"
-- Mason bootstrap script
local ok, mason_registry = pcall(require, 'mason-registry')
if not ok then
  print('Mason not available yet')
  return
end

-- Wait for registry to load
if not mason_registry.is_installed('lua-language-server') then
  mason_registry.refresh()
end

-- Get all tools that should be installed from LSP config
local tools = {
  -- LSP servers
  'lua-language-server',
  'pyright',
  'rust-analyzer',
  'typescript-language-server',
  -- Formatters
  'stylua',
  'black',
  'isort',
  'prettier',
  -- Linters (if needed)
}

local installed = 0
for _, tool_name in ipairs(tools) do
  local ok, pkg = pcall(mason_registry.get_package, tool_name)
  if ok and not pkg:is_installed() then
    print('Installing ' .. tool_name)
    pkg:install()
    installed = installed + 1
  end
end

print('Queued ' .. installed .. ' tools for installation')
"@

$masonScriptPath = "$env:TEMP\nvim-mason-bootstrap.lua"
$masonScript | Out-File -FilePath $masonScriptPath -Encoding UTF8

$masonOutput = nvim --headless -c "luafile $masonScriptPath" -c "sleep 5" +qa 2>&1

if ($Verbose) {
  Write-Host "`n--- Mason Output ---" -ForegroundColor Gray
  $masonOutput | Write-Host
  Write-Host "--- End Output ---`n" -ForegroundColor Gray
}

# Give Mason time to install tools in background
Write-Host "  ℹ Mason installations run in background" -ForegroundColor Gray
Write-Host "  ℹ Check progress with :Mason in Neovim" -ForegroundColor Gray

Remove-Item $masonScriptPath -Force -ErrorAction SilentlyContinue

# Step 6: Final verification
Write-Host "`n✅ Step 6: Verification" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

$allGood = $true

# Check plugins
if (Test-Path $lazyDir) {
  $pluginCount = (Get-ChildItem $lazyDir -Directory -ErrorAction SilentlyContinue | Measure-Object).Count
  Write-Host "  📦 Plugins: $pluginCount" -ForegroundColor Green
  if ($pluginCount -lt 50) {
    Write-Host "     ⚠ Expected ~60+ plugins" -ForegroundColor Yellow
    $allGood = $false
  }
} else {
  Write-Host "  📦 Plugins: ✗ None installed" -ForegroundColor Red
  $allGood = $false
}

# Check parsers
$parserDir = "$dataDir\site\parser"
if (Test-Path $parserDir) {
  $parserCount = (Get-ChildItem $parserDir -Filter "*.so" -ErrorAction SilentlyContinue | Measure-Object).Count
  Write-Host "  🌳 Treesitter parsers: $parserCount" -ForegroundColor Green
  if ($parserCount -eq 0 -and $hasCompiler) {
    Write-Host "     ⚠ No parsers compiled" -ForegroundColor Yellow
    $allGood = $false
  }
} else {
  if ($hasCompiler) {
    Write-Host "  🌳 Treesitter parsers: ✗ None compiled" -ForegroundColor Red
    $allGood = $false
  } else {
    Write-Host "  🌳 Treesitter parsers: ⏭️  Skipped (no compiler)" -ForegroundColor Gray
  }
}

# Check Mason
$masonDir = "$dataDir\mason\packages"
if (Test-Path $masonDir) {
  $masonCount = (Get-ChildItem $masonDir -Directory -ErrorAction SilentlyContinue | Measure-Object).Count
  Write-Host "  🔧 Mason packages: $masonCount (installing in background)" -ForegroundColor Green
} else {
  Write-Host "  🔧 Mason packages: 0 (will install on first use)" -ForegroundColor Gray
}

# Mark as bootstrapped
if ($allGood) {
  Get-Date | Out-File -FilePath $bootstrapMarker -Encoding UTF8
  Write-Host "`n✨ Bootstrap complete!" -ForegroundColor Green
  Write-Host "   Neovim is ready to use." -ForegroundColor Green
} else {
  Write-Host "`n⚠ Bootstrap completed with warnings" -ForegroundColor Yellow
  Write-Host "   Neovim should work, but may need manual fixes." -ForegroundColor Yellow
}

Write-Host "`n📚 Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Launch Neovim: nvim" -ForegroundColor Gray
Write-Host "  2. Check health: :checkhealth" -ForegroundColor Gray
Write-Host "  3. View plugins: :Lazy" -ForegroundColor Gray
Write-Host "  4. Check Mason: :Mason" -ForegroundColor Gray
Write-Host ""
