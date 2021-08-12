$location = Read-Host 'What is the path of computers? i.e. "c:\scripts\computernames.txt"' 
$computers = Get-Content -Path $location | Get-ADComputer
$groupname = Read-Host 'Whats the group name?'

Write-Host "Found" + $computers

Foreach ($computer in $computers) {
Remove-ADGroupMember -Identity $groupname -Member $computer –Confirm:$false
}


