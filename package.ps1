<#
NOTE:
If PowerShell blocks this script ("running scripts is disabled"),
run the following in the same PowerShell window:

  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

This applies only to the current session and resets when the window closes.

USAGE (basic):
  .\package.ps1
  .\package.ps1 -Version v1.0.0

USAGE (when paths differ / advanced):
  .\package.ps1 `
    -Version v1.0.0 `
    -PortDir .\CS16 `
    -LauncherSh .\CS16.sh `
    -DocsPath .\docs `
    -OutDir .\dist

#>

param(
  [string]$Version = "dev",

  # What to include
  [string]$PortDir    = ".\counter-strike",
  [string]$LauncherSh = ".\Counter-Strike.sh",
  [string]$DocsPath   = ".\docs",   # can be a folder or a single file (README.html / README.md). Set "" to skip.

  # Output
  [string]$OutDir     = ".\dist"
)

$ErrorActionPreference = "Stop"

function Assert-Exists($path, $label) {
  if (![string]::IsNullOrWhiteSpace($path) -and !(Test-Path $path)) {
    throw "Missing ${label}: ${path}"
  }
}

function Ensure-Dir($path) {
  if (!(Test-Path $path)) { New-Item -ItemType Directory -Force -Path $path | Out-Null }
}

Assert-Exists $PortDir "port directory"
Assert-Exists $LauncherSh "launcher script"
if ($DocsPath -ne "" -and !(Test-Path $DocsPath)) {
  Write-Host "DocsPath not found, skipping: $DocsPath"
  $DocsPath = ""
}

Ensure-Dir $OutDir
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not [System.IO.Path]::IsPathRooted($OutDir)) {
  $OutDir = Join-Path $ScriptRoot $OutDir
}

$portName = Split-Path $PortDir -Leaf
$zipName  = ("{0}-{1}.zip" -f ($portName -replace " ", "_"), $Version)
$zipPath  = Join-Path $OutDir $zipName

if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

# Build items list
$items = @()
$items += (Resolve-Path $LauncherSh).Path
$items += (Resolve-Path $PortDir).Path

if ($DocsPath -ne "") {
  $docsResolved = (Resolve-Path $DocsPath).Path
  if (Test-Path $docsResolved -PathType Container) {
    # Add contents of folder so the folder name itself isn't created in the zip
    $items += (Join-Path $docsResolved "*")
  } else {
    # Single file path (README.html / README.md)
    $items += $docsResolved
  }
}

Compress-Archive -Path $items -DestinationPath $zipPath -Force

Write-Host "Created: $zipPath"
Write-Host "Included:"
$items | ForEach-Object { Write-Host " - $_" }

Write-Host "`nZip preview (top 30):"
try {
  $zipPathAbs = [System.IO.Path]::GetFullPath($zipPath)
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  [System.IO.Compression.ZipFile]::OpenRead($zipPathAbs).Entries |
    Select-Object -First 30 FullName, Length |
    Format-Table -AutoSize
} catch {
  Write-Host "Zip preview skipped: $($_.Exception.Message)"
}