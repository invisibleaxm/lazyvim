#!/usr/bin/env pwsh
# Neovim Quick Setup - All-in-one script for fresh installations
# Combines bootstrap + cleanup for foolproof setup

param(
  [switch]$Force,
  [switch]$Verbose,
  [switch]$SkipBootstrap
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$bootstrapScript = Join-Path $scriptDir "bootstrap.ps1"
$cleanupScript = Join-Path $scriptDir "cleanup.ps1"

Write-Host "`n🎯 Neovim Quick Setup" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Run cleanup first to ensure clean slate
Write-Host "🧹 Step 1: Cleaning up any existing issues..." -ForegroundColor Cyan
& $cleanupScript -SkipSync
Write-Host ""

# Step 2: Bootstrap if not skipped
if (-not $SkipBootstrap) {
  Write-Host "🚀 Step 2: Running bootstrap..." -ForegroundColor Cyan

  $bootstrapArgs = @()
  if ($Force) { $bootstrapArgs += "-Force" }
  if ($Verbose) { $bootstrapArgs += "-Verbose" }

  & $bootstrapScript @bootstrapArgs
} else {
  Write-Host "⏭️  Step 2: Skipping bootstrap" -ForegroundColor Gray
}

Write-Host "`n✨ Setup complete!" -ForegroundColor Green
Write-Host ""
