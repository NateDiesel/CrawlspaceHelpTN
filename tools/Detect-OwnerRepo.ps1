$ErrorActionPreference = 'Stop'
Set-Location "$PSScriptRoot\.."  # repo root
$remote = git remote get-url origin
if (-not $remote) { throw 'No git remote found.' }
if ($remote -match 'github\.com[:/](?<owner>[^/]+)/(?<repo>[^\.]+)') {
  $owner = $Matches['owner']; $repo = $Matches['repo']
} else { throw ('Could not parse owner/repo from remote: ' + $remote) }
Write-Host ("Owner/Repo detected: {0}/{1}" -f $owner,$repo)