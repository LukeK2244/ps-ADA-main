# Master SQL Build Script - ADA app

$masterFile = Join-Path $PSScriptRoot "\ADA-master.sql"

$buildMsg = "-- ADA Master SQL`n"
Set-Content -Path $masterFile -Value $buildMsg
Write-Output $buildMsg

# Set FK Constraints Off
Add-Content -Path $masterFile -Value 'SET FOREIGN_KEY_CHECKS = 0;'

$folders = (Get-ChildItem $PSScriptRoot -Directory | sort).FullName

Foreach ($f in $folders) {
  Write-Output ("Processing {0}" -f (Get-Item $f).Name)
  $sqlFiles = Join-Path $f "\*.sql" | Get-Item
  $sqlFiles | sort | foreach { Add-Content -Value $(Get-Content $_) -Path $masterFile}
}

# Set FK Constraints Back On
Add-Content -Path $masterFile -Value 'SET FOREIGN_KEY_CHECKS = 1;'

$completeMsg = "-- ADA Master SQL Build Complete`n"
Add-Content -Path $masterFile -Value $completeMsg
Write-Output $completeMsg
