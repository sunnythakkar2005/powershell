<#
    Excample usage:

    .\KillProcess.ps1 'pcname' 'processname'
 
#>
$pcname = $args[0]
$processname = $arg[1]
(Get-WmiObject Win32_Process -ComputerName $pcname | ?{ $_.ProcessName -match $processname }).Terminate()