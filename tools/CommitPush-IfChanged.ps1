$ErrorActionPreference = 'Stop'
Set-Location "$PSScriptRoot\.."  # repo root
git add README.md .github/workflows/link-check.yml 2>$null | Out-Null
git diff --staged --quiet
if ($LASTEXITCODE -ne 0) {
  git commit -m 'docs: add Link Check badge; ci: add nightly schedule' | Out-Null
  git push | Out-Null
  Write-Host 'Changes committed & pushed.'
} else {
  Write-Host 'No changes to commit.'
}