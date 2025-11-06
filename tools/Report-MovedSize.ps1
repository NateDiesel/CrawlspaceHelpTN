param(
  [string]$DestRoot = "$env:USERPROFILE\Projects\_staging\media_raw\CrawlspaceHelpTN"
)
$ErrorActionPreference = 'Stop'
$targets = @()
$targets += (Join-Path $DestRoot 'raw')
$targets += (Join-Path $DestRoot 'crawl-space-vapor-barrier-installation')
$targets += (Join-Path $DestRoot 'short_video_001')
$targets += (Join-Path $DestRoot 'short_video_002')
$total = 0
foreach($t in $targets){
  if(Test-Path -LiteralPath $t){
    $sum = (Get-ChildItem -LiteralPath $t -Recurse -File | Measure-Object -Sum Length).Sum
    if($sum){ $total += [double]$sum }
  }
}
$mb = if($total){ [math]::Round($total/1MB, 2) } else { 0 }
Write-Host ("Moved media total size: {0} MB" -f $mb)