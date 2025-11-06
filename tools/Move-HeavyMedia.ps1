param(
  [string]$ProjectRoot = "C:\Users\Nathan\Projects\CrawlspaceHelpTN",
  [string]$DestRoot = "$env:USERPROFILE\Projects\_staging\media_raw\CrawlspaceHelpTN"
)

$ErrorActionPreference = 'Stop'

function Move-IfExists {
  param(
    [Parameter(Mandatory=$true)][string]$Source,
    [Parameter(Mandatory=$true)][string]$Destination
  )
  if (Test-Path -LiteralPath $Source) {
    $destParent = Split-Path -Path $Destination -Parent
    if (-not (Test-Path -LiteralPath $destParent)) {
      New-Item -ItemType Directory -Path $destParent -Force | Out-Null
    }
    if (-not (Test-Path -LiteralPath $Destination)) {
      Write-Host ("Moving: {0} -> {1}" -f $Source, $Destination)
      Move-Item -LiteralPath $Source -Destination $Destination -Force
    } else {
      Write-Host ("Destination exists, skipping move: {0}" -f $Destination)
    }
  } else {
    Write-Host ("Not found (skip): {0}" -f $Source)
  }
}

# Ensure destination root exists
if (-not (Test-Path -LiteralPath $DestRoot)) {
  New-Item -ItemType Directory -Path $DestRoot -Force | Out-Null
}

# Sources inside project
$raw = Join-Path $ProjectRoot "assets\images\raw"
$proc = Join-Path $ProjectRoot "assets\images\processed\crawl-space-vapor-barrier-installation"
$sv1 = Join-Path $ProjectRoot "assets\images\short_video_001"
$sv2 = Join-Path $ProjectRoot "assets\images\short_video_002"

# Destinations
Move-IfExists -Source $raw -Destination (Join-Path $DestRoot "raw")
Move-IfExists -Source $proc -Destination (Join-Path $DestRoot "crawl-space-vapor-barrier-installation")
Move-IfExists -Source $sv1 -Destination (Join-Path $DestRoot "short_video_001")
Move-IfExists -Source $sv2 -Destination (Join-Path $DestRoot "short_video_002")

Write-Host "Done."