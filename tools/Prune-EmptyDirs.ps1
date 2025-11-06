param(
  [string]$RepoRoot = "C:\\Users\\Nathan\\Projects\\CrawlspaceHelpTN"
)
$ErrorActionPreference = 'Stop'
$images = Join-Path $RepoRoot 'assets\\images'
if (Test-Path -LiteralPath $images) {
  # Remove empty directories bottom-up
  $dirs = Get-ChildItem -LiteralPath $images -Directory -Recurse | Sort-Object FullName -Descending
  $removed = 0
  foreach ($d in $dirs) {
    $hasFiles = Get-ChildItem -LiteralPath $d.FullName -Force -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    $hasDirs = Get-ChildItem -LiteralPath $d.FullName -Force -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $hasFiles -and -not $hasDirs) {
      Remove-Item -LiteralPath $d.FullName -Force -ErrorAction SilentlyContinue
      $removed++
    }
  }
  Write-Host ("Pruned empty directories: {0}" -f $removed)
} else {
  Write-Host "No assets/images directory to prune."
}