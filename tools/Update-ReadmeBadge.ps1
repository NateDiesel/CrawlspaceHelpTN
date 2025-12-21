$ErrorActionPreference = 'Stop'
Set-Location "$PSScriptRoot\.."  # repo root
$readme = 'README.md'
if (-not (Test-Path -LiteralPath $readme)) { Set-Content -LiteralPath $readme '# Crawlspace Help TN' }
$origin = git remote get-url origin
if ($origin -match 'github\.com[:/](?<owner>[^/]+)/(?<repo>[^\.]+)') { $owner=$Matches['owner']; $repo=$Matches['repo'] } else { throw 'Cannot parse owner/repo' }
$badge = ('[![Link Check](https://github.com/{0}/{1}/actions/workflows/link-check.yml/badge.svg)](https://github.com/{0}/{1}/actions/workflows/link-check.yml)' -f $owner,$repo)

$content = Get-Content -LiteralPath $readme -Raw
if ($content -notmatch [Regex]::Escape($badge)) {
  if ($content -match '^(# .+)$') {
    $content = $content -replace '^(# .+)$', ('$1' + [Environment]::NewLine + $badge)
  } else {
    $content = '# Crawlspace Help TN' + [Environment]::NewLine + $badge + [Environment]::NewLine + [Environment]::NewLine + $content
  }
  Set-Content -LiteralPath $readme -Value $content -NoNewline
  Write-Host 'README badge inserted/updated.'
} else {
  Write-Host 'README already contains Link Check badge.'
}