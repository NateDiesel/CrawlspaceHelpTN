param(
  [string]$WorkspaceRoot = "C:\\Users\\Nathan\\Projects"
)

$ErrorActionPreference = 'Stop'

$repoRoot = Join-Path $WorkspaceRoot 'CrawlspaceHelpTN'
if (!(Test-Path -LiteralPath $repoRoot)) { throw "Repo not found at $repoRoot" }

Write-Host "=== 1) Re-scan for files > 500 KB inside repo ==="
$assets = Join-Path $repoRoot 'assets\\images'
if (Test-Path -LiteralPath $assets) {
  $big = Get-ChildItem -LiteralPath $assets -Recurse -File | Where-Object { $_.Length -gt 500KB }
  if ($big) {
    Write-Host "WARNING: Still-large files inside repo (>500 KB):"
    $big | Select-Object FullName,@{n='MB';e={[math]::Round($_.Length/1MB,2)}} | Format-Table -AutoSize
  } else {
    Write-Host "OK: No files >500 KB remain in assets/images."
  }
} else {
  Write-Host "INFO: assets/images does not exist (already moved/clean)."
}

Write-Host "`n=== 2) Confirm heavy dirs are gone from repo ==="
$shouldBeGone = @()
$shouldBeGone += (Join-Path $repoRoot 'assets\\images\\raw')
$shouldBeGone += (Join-Path $repoRoot 'assets\\images\\processed\\crawl-space-vapor-barrier-installation')
$shouldBeGone += (Join-Path $repoRoot 'assets\\images\\short_video_001')
$shouldBeGone += (Join-Path $repoRoot 'assets\\images\\short_video_002')
foreach ($p in $shouldBeGone) {
  $rel = $p.Replace($repoRoot + [IO.Path]::DirectorySeparatorChar, '')
  if (Test-Path -LiteralPath $p) {
    Write-Host "WARNING: Still present in repo: $rel - remove or move, then update git index."
  } else {
    Write-Host "OK: Not present in repo: $rel"
  }
}

Write-Host "`n=== 3) Ensure .gitignore rules (idempotent) ==="
$gi = Join-Path $repoRoot '.gitignore'
if (!(Test-Path -LiteralPath $gi)) { New-Item -ItemType File -Path $gi -Force | Out-Null }
$rules = @(
  '# Heavy media (keep repo lean)',
  'assets/images/raw/',
  'assets/images/**/ref_images/',
  'assets/images/short_video_*/',
  'assets/images/processed/crawl-space-vapor-barrier-installation/',
  '*.psd','*.tif','*.tiff','*.heic','*.mov','*.mp4'
)
$existing = Get-Content -LiteralPath $gi -ErrorAction SilentlyContinue
if ($existing -eq $null) { $existing = @() }
$toAppend = $rules | Where-Object { $_ -notin $existing }
if ($toAppend.Count -gt 0) {
  Add-Content -LiteralPath $gi -Value ""
  Add-Content -LiteralPath $gi -Value $toAppend
  Write-Host "OK: .gitignore updated"
} else {
  Write-Host "INFO: .gitignore already contains the rules"
}

Write-Host "`n=== 4) Git clean-up + push (only if there are changes) ==="
Push-Location $repoRoot
git add .gitignore | Out-Null
$rmTargets = @(
  'assets/images/raw',
  'assets/images/short_video_001',
  'assets/images/short_video_002',
  'assets/images/processed/crawl-space-vapor-barrier-installation'
)
foreach ($r in $rmTargets) {
  # Untrack if present in index; ignore if not tracked
  git rm -r --cached --ignore-unmatch $r 2>$null | Out-Null
}

$status = git status --porcelain
if ($status) {
  git commit -m "chore: finalize heavy-media move and ignore rules" 2>$null | Out-Null
  git push | Out-Null
  Write-Host "OK: Repo committed and pushed."
} else {
  Write-Host "INFO: No changes to commit."
}
Pop-Location

Write-Host "`n=== 5) Moved size summary ==="
& (Join-Path $repoRoot 'tools\\Report-MovedSize.ps1')

Write-Host "`nVerification complete."
