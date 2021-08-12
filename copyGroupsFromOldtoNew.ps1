$oldpc = Read-Host 'Enter Old PC' 
$oldcomputer = Get-ADComputer $oldpc
$newPC = Read-Host 'Enter New PC'
$newcomputer = Get-ADComputer $newPC



#removing any old groups from new pc
Get-ADComputer -Identity $newPC -Properties MemberOf | ForEach-Object {
  $_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Confirm:$false

  Write-Host "removing new computer $computer from all groups"
}
#Getting list of groups from old pc
$listofGroups = Get-ADComputer $oldcomputer -Properties MemberOf |  ForEach-Object{ $_.MemberOf | %{Get-AdObject $_ }}

#copying new groups
Foreach ($group in $listofGroups){
Add-ADGroupMember -ID $group -Members (Get-ADComputer $newPC).distinguishedname
Write-Host "adding " + $group + "to " + $newPC
}