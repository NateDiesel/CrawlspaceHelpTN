$ErrorActionPreference = 'Stop'
Set-Location "$PSScriptRoot\.."  # repo root
(Get-Content -LiteralPath 'README.md' -First 5) | ForEach-Object { Write-Host $_ }
$match = Select-String -Path '.github/workflows/link-check.yml' -Pattern "cron: '0 5 \* \* \*'"
if ($match) { Write-Host ('Cron line found: ' + $match.Line) } else { Write-Host 'Cron line NOT found.' }
Write-Host 'Badge + nightly cron verification complete.'