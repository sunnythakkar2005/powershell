$pc = Read-Host 'Enter PC'
$fileToCheck = "\\" + $pc + "\c$\Windows\ccmcache\Dell-Command-Update-Application_8D5MC_WIN_4.3.0_A00.EXE"
$LenovoCheck = "C:\Program Files (x86)\Lenovo\System Update\tvsu.exe"
$checkIfInstalled = "\\" + $pc + "\c$\"


if (Test-Path $fileToCheck -PathType leaf)
{
    Write-Host "Latest Client is already installed, running updates"

    Invoke-Command $pc{
    $env:path += ';C:\Program Files (x86)\Dell\CommandUpdate'; 
    dcu-cli /applyUpdates -autoSuspendBitLocker=enable -outputLog=C:\Dell_Update.log }



}else
{
    Write-Host "Installing Latest Client"
    Copy-Item -Path \\nvfnsw01\Software_Repository\Desktop\NSW\dell\Dell-Command-Update-Application_8D5MC_WIN_4.3.0_A00.EXE -Destination ("\\" + $pc + "\c$\Windows\ccmcache\")

    invoke-command $pc {
   
    Start-Process -FilePath "c:\Windows\ccmcache\Dell-Command-Update-Application_8D5MC_WIN_4.3.0_A00.EXE" -ArgumentList '/s' -Verbose -Wait;
    set-service -name 'DellClientManagementService' -StartupType Manual;}

    Invoke-Command $pc{
    $env:path += ';C:\Program Files (x86)\Dell\CommandUpdate'; 
    dcu-cli /applyUpdates -autoSuspendBitLocker=enable -outputLog=C:\Dell_Update.log }
}





