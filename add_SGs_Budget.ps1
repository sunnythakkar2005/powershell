$location = Read-Host 'What is the path of computers? i.e. "c:\scripts\computernames.txt"'
$computers = Get-Content -Path $location

Write-Host "Found" + $computers

Foreach ($computer in $computers) {

 $obj = Get-ADComputer $computer
 Add-ADGroupMember -ID 'GPFGRP_CMP_Workstation Local Admins_Deny' -Members $obj
 Add-ADGroupMember -ID 'SW-Methode Client Suite 610B9F_5' -Members $obj
 Add-ADGroupMember -ID '1Switch Power Policy Exclusion' -Members $obj
 Add-ADGroupMember -ID 'GPFGRP_NAT_Disable_Power_Management' -Members $obj

}