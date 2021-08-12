$pc = Read-Host 'Enter PC'


$fileToCheck = "\\" + $pc + "\c$\Windows\ccmcache\Dell-Command-Update-Application_8D5MC_WIN_4.3.0_A00.EXE"

Write-Host $fileToCheck
if (Test-Path $fileToCheck -PathType leaf)
{
    Write-Host "File  here"
}
else
{
    Write-Host "File not here"
}