$pcname = Read-Host "Enter PC Name"

If (!(Test-Connection -ComputerName $pcname -Count 1 -Quiet)) { 
  Write-Host "$pcname not on network."
  
}
else
{
$newsPP =  Get-WmiObject -ComputerName $pcname -Namespace root\cimv2\power -Class Win32_PowerPlan -Filter "ElementName ='News Corp Aus Power Management'"
    if ($newsPP.IsActive -eq "True") {

            Write-Host "Power Plan is active" 

        } Else { 

            Write-Host "News plan is not active"

#powercfg /setactive db310065-829b-4671-9647-2261c00e86ef
        } 
}




