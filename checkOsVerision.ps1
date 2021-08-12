
$pcname = Read-Host -Prompt "Enter PC Name"
Invoke-Command -ComputerName $pcname -ScriptBlock { Get-ComputerInfo | select windowsversion }
