$ErrorActionPreference = 'Continue'
$env:PATH = [System.Environment]::GetEnvironmentVariable('PATH','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('PATH','User')
Set-Location $PSScriptRoot

Write-Output '--- current releases ---'
gh release list 2>&1

Write-Output '--- create release v2.0.0 ---'
$notes = @"
Simulation dataset release. The repository now contains nine CarSim runs (121-129, 100 Hz, 580 channels) used to build the simulation pre-training set of the manuscript, shipped as three zipped archives. The real-vehicle recordings of v1.0.0 remain available under their own version DOI.
"@
gh release create v2.0.0 --title "v2.0.0 - CarSim simulation dataset" --notes $notes 2>&1
Write-Output ("exit: " + $LASTEXITCODE)

Write-Output '--- waiting for Zenodo to archive v2.0.0 ---'
$repo = 'lateral-velocity-dataset'
$found = $null
for ($i = 0; $i -lt 72; $i++) {
    Start-Sleep -Seconds 5
    try { $r = Invoke-RestMethod -Uri 'https://zenodo.org/api/records?sort=newest&size=30' -TimeoutSec 25 } catch { continue }
    foreach ($hit in $r.hits.hits) {
        $ids = @()
        if ($hit.metadata.related_identifiers) { $ids = $hit.metadata.related_identifiers | ForEach-Object { $_.identifier } }
        if (($ids -join ' ') -match $repo) {
            if ($hit.metadata.version -eq 'v2.0.0') { $found = $hit; break }
        }
    }
    if ($found) { Write-Output ("  found after " + (($i+1)*5) + " s"); break }
    if (($i % 12) -eq 11) { Write-Output ("  still waiting (" + (($i+1)*5) + " s)") }
}

if ($found) {
    Write-Output '--- v2.0.0 record ---'
    Write-Output ("doi        : " + $found.doi)
    Write-Output ("conceptdoi : " + $found.conceptdoi)
    Write-Output ("version    : " + $found.metadata.version)
    Write-Output ("files      : " + (($found.files | ForEach-Object { $_.key + ' (' + [math]::Round($_.size/1MB,1) + ' MB)' }) -join ', '))
} else {
    Write-Output 'NOT FOUND within 6 minutes'
}
