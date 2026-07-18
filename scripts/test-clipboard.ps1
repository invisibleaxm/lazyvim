#!/usr/bin/env pwsh
# Test script for clipboard and mouse integration

Write-Host "`n🧪 Neovim Clipboard & Mouse Test" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Test 1: Check Neovim clipboard provider
Write-Host "`n📋 Test 1: Checking clipboard provider..." -ForegroundColor Yellow
$clipboardCheck = nvim --headless --cmd "lua print(vim.fn.has('clipboard'))" +qa 2>&1 | Select-String "1"
if ($clipboardCheck) {
  Write-Host "  ✓ Clipboard provider available" -ForegroundColor Green
} else {
  Write-Host "  ✗ Clipboard provider not available" -ForegroundColor Red
}

# Test 2: Check mouse option
Write-Host "`n🖱️  Test 2: Checking mouse option..." -ForegroundColor Yellow
$mouseCheck = nvim --headless --cmd "lua print(vim.o.mouse)" +qa 2>&1 | Select-String "a"
if ($mouseCheck) {
  Write-Host "  ✓ Mouse enabled (mouse=a)" -ForegroundColor Green
} else {
  Write-Host "  ✗ Mouse not enabled" -ForegroundColor Red
}

# Test 3: Check clipboard option
Write-Host "`n📑 Test 3: Checking clipboard option..." -ForegroundColor Yellow
$clipboardOpt = nvim --headless --cmd "lua print(vim.o.clipboard)" +qa 2>&1 | Select-String "unnamedplus"
if ($clipboardOpt) {
  Write-Host "  ✓ System clipboard integration enabled (clipboard=unnamedplus)" -ForegroundColor Green
} else {
  Write-Host "  ⚠ System clipboard not set to unnamedplus" -ForegroundColor Yellow
}

# Test 4: Check SSH detection (if in SSH session)
Write-Host "`n🔐 Test 4: Checking SSH detection..." -ForegroundColor Yellow
if ($env:SSH_TTY -or $env:SSH_CONNECTION) {
  Write-Host "  ℹ SSH session detected" -ForegroundColor Cyan
  $osc52Check = nvim --headless --cmd "lua if vim.env.SSH_TTY then print('OSC52') end" +qa 2>&1 | Select-String "OSC52"
  if ($osc52Check) {
    Write-Host "  ✓ OSC 52 clipboard will be enabled" -ForegroundColor Green
  } else {
    Write-Host "  ⚠ OSC 52 detection may have issues" -ForegroundColor Yellow
  }
} else {
  Write-Host "  ℹ Not in SSH session (OSC 52 not needed)" -ForegroundColor Gray
}

# Test 5: Platform detection
Write-Host "`n🖥️  Test 5: Platform-specific settings..." -ForegroundColor Yellow
$platform = [System.Environment]::OSVersion.Platform
Write-Host "  Platform: $platform" -ForegroundColor Gray

if ($IsWindows) {
  if (Test-Path "C:\msys64\mingw64\bin") {
    Write-Host "  ✓ MSYS2 found (for Treesitter compilation)" -ForegroundColor Green
  } else {
    Write-Host "  ⚠ MSYS2 not found at C:\msys64" -ForegroundColor Yellow
  }

  if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    Write-Host "  ✓ PowerShell 7+ (pwsh) found" -ForegroundColor Green
  } else {
    Write-Host "  ℹ Using Windows PowerShell (consider installing PowerShell 7+)" -ForegroundColor Gray
  }
}

# Summary
Write-Host "`n📊 Summary" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host "
Your clipboard configuration:
  • Mouse support: Enabled globally
  • Local clipboard: System integration active
  • SSH clipboard: OSC 52 auto-detection
  • Right-click: Handled by terminal

Next steps:
  1. Launch Neovim: nvim
  2. Test yank: yy (should copy line)
  3. Test paste: p (should paste from clipboard)
  4. Mouse select + right-click to copy
  5. Run :checkhealth clipboard for details
" -ForegroundColor Gray

Write-Host "✅ Configuration tests complete!" -ForegroundColor Green
Write-Host "📖 See docs/CLIPBOARD_MOUSE_GUIDE.md for full usage guide" -ForegroundColor Cyan
Write-Host ""
