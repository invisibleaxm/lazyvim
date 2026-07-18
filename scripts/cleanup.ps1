#!/usr/bin/env pwsh
# Neovim Lazy.nvim Cleanup and Sync Script
# Cleans corrupted plugins, resets local changes, and syncs all plugins

param(
  [switch]$FullClean,  # Remove entire lazy plugin directory
  [switch]$SkipSync    # Skip the final sync step
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
$parserDir = "$dataDir\site\parser"

Write-Host "`n🧹 Neovim Lazy.nvim Cleanup Script" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Function to safely remove file/directory
function Remove-Safely {
  param([string]$Path, [string]$Description)
  if (Test-Path $Path) {
    try {
      Remove-Item $Path -Recurse -Force -ErrorAction Stop
      Write-Host "  ✓ Removed $Description" -ForegroundColor Green
      return $true
    } catch {
      Write-Host "  ⚠ Failed to remove $Description : $_" -ForegroundColor Yellow
      return $false
    }
  }
  return $false
}

# Step 1: Remove lock file
Write-Host "`n📌 Step 1: Removing lock file..." -ForegroundColor Cyan
Remove-Safely "$configDir\lazy-lock.json" "lazy-lock.json"

# Step 2: Full clean if requested
if ($FullClean) {
  Write-Host "`n🗑️  Step 2: Full clean (removing all plugins)..." -ForegroundColor Cyan
  if (Remove-Safely $lazyDir "all plugins") {
    Write-Host "  ℹ All plugins will be reinstalled on next launch" -ForegroundColor Gray
  }
} else {
  # Step 2: Clean corrupted parser files
  Write-Host "`n🔍 Step 2: Cleaning corrupted parser files..." -ForegroundColor Cyan
  if (Test-Path $parserDir) {
    $corrupted = Get-ChildItem $parserDir -Filter "*.so2*" -ErrorAction SilentlyContinue
    if ($corrupted) {
      $corrupted | ForEach-Object {
        Write-Host "  Removing: $($_.Name)" -ForegroundColor Yellow
        Remove-Item $_.FullName -Force
      }
      Write-Host "  ✓ Removed $($corrupted.Count) corrupted parser(s)" -ForegroundColor Green
    } else {
      Write-Host "  ✓ No corrupted parsers found" -ForegroundColor Green
    }
  } else {
    Write-Host "  ℹ Parser directory doesn't exist yet" -ForegroundColor Gray
  }

  # Step 3: Clean .cloning temp directories
  Write-Host "`n🧼 Step 3: Cleaning temporary clone directories..." -ForegroundColor Cyan
  if (Test-Path $lazyDir) {
    $cloning = Get-ChildItem $lazyDir -Filter "*.cloning" -ErrorAction SilentlyContinue
    if ($cloning) {
      $cloning | ForEach-Object {
        Write-Host "  Removing: $($_.Name)" -ForegroundColor Yellow
        Remove-Item $_.FullName -Recurse -Force
      }
      Write-Host "  ✓ Removed $($cloning.Count) temp clone dir(s)" -ForegroundColor Green
    } else {
      Write-Host "  ✓ No temp directories found" -ForegroundColor Green
    }
  }

  # Step 4: Reset plugins with local changes
  Write-Host "`n🔄 Step 4: Resetting plugins with local changes..." -ForegroundColor Cyan
  if (Test-Path $lazyDir) {
    $resetCount = 0
    Get-ChildItem $lazyDir -Directory | ForEach-Object {
      Push-Location $_.FullName
      $status = git status --porcelain 2>$null
      if ($status) {
        Write-Host "  Resetting: $($_.Name)" -ForegroundColor Yellow
        git reset --hard HEAD 2>&1 | Out-Null
        git clean -fd 2>&1 | Out-Null
        $resetCount++
      }
      Pop-Location
    }
    if ($resetCount -gt 0) {
      Write-Host "  ✓ Reset $resetCount plugin(s)" -ForegroundColor Green
    } else {
      Write-Host "  ✓ No local changes found" -ForegroundColor Green
    }
  }
}

# Step 5: Sync plugins
if (-not $SkipSync) {
  Write-Host "`n🔄 Step 5: Syncing all plugins..." -ForegroundColor Cyan
  Write-Host "  This may take a minute..." -ForegroundColor Gray

  $syncOutput = nvim --headless "+Lazy! sync" +qa 2>&1

  # Check for errors
  $errors = $syncOutput | Select-String -Pattern "error|ERROR|failed|FAILED|local changes" -CaseSensitive:$false

  if ($errors) {
    Write-Host "  ⚠ Sync completed with warnings:" -ForegroundColor Yellow
    $errors | ForEach-Object { Write-Host "    $_" -ForegroundColor Yellow }
  } else {
    Write-Host "  ✓ All plugins synced successfully" -ForegroundColor Green
  }
} else {
  Write-Host "`n⏭️  Skipping sync step (use -SkipSync:$false to sync)" -ForegroundColor Gray
}

# Step 6: Summary
Write-Host "`n📊 Summary" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

if (Test-Path $lazyDir) {
  $pluginCount = (Get-ChildItem $lazyDir -Directory | Measure-Object).Count
  Write-Host "  📦 Plugins: $pluginCount" -ForegroundColor Green
} else {
  Write-Host "  📦 Plugins: 0 (will install on next launch)" -ForegroundColor Yellow
}

if (Test-Path $parserDir) {
  $parserCount = (Get-ChildItem $parserDir -Filter "*.so" -ErrorAction SilentlyContinue | Measure-Object).Count
  Write-Host "  🌳 Treesitter parsers: $parserCount" -ForegroundColor Green
} else {
  Write-Host "  🌳 Treesitter parsers: 0" -ForegroundColor Gray
}

Write-Host "`n✨ Cleanup complete! Launch Neovim to verify." -ForegroundColor Green
Write-Host ""
