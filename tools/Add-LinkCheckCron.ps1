$ErrorActionPreference = 'Stop'
Set-Location "$PSScriptRoot\.."  # repo root
$wf = '.github/workflows/link-check.yml'
if (-not (Test-Path -LiteralPath $wf)) { throw ('Workflow file not found: ' + $wf) }
$y = Get-Content -LiteralPath $wf -Raw

if ($y -notmatch '(?ms)^\s*on:\s') {
  $y = 'on:' + [Environment]::NewLine + '  workflow_dispatch:' + [Environment]::NewLine + $y
}

if ($y -notmatch '(?ms)^\s*on:\s*(?:.*\n)*\s*schedule:\s*(?:.*\n)*- cron:\s*''0 5 \* \* \*''') {
  if ($y -match '(?ms)^(?<head>.*?^\s*on:\s*(?:.*\n)*?)(?<tail>jobs:.*)$') {
    $head = $Matches['head']; $tail = $Matches['tail']
    if ($head -notmatch '(?ms)^\s*on:\s*(?:.*\n)*\s*schedule:\s') {
      $head = $head.TrimEnd() + [Environment]::NewLine + '  schedule:' + [Environment]::NewLine + '    - cron: ''0 5 * * *''' + [Environment]::NewLine
    } else {
      $head = $head -replace '(?ms)(^\s*on:\s*(?:.*\n)*?\s*schedule:\s*(?:.*\n)*)', ('$1' + '    - cron: ''0 5 * * *''' + [Environment]::NewLine)
    }
    $y = $head + $tail
  } else {
    $y = $y.TrimEnd() + [Environment]::NewLine + '  schedule:' + [Environment]::NewLine + '    - cron: ''0 5 * * *''' + [Environment]::NewLine
  }
  Set-Content -LiteralPath $wf -Value $y -NoNewline
  Write-Host 'Added nightly schedule (05:00 UTC) to link-check workflow.'
} else {
  Write-Host 'Nightly schedule already present.'
}