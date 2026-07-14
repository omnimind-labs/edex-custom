# Local build helper for eDEX Custom on Windows
# Usage: .\scripts\build-local.ps1
# Requires: Rust + MSVC build tools, Node.js LTS, pnpm

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot\..

Write-Host "Installing JS dependencies..." -ForegroundColor Cyan
pnpm install

Write-Host "Running Tauri build..." -ForegroundColor Cyan
pnpm tauri build

Write-Host "Done! Installer is in src-tauri\target\release\bundle\" -ForegroundColor Green
