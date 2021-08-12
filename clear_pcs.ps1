$location = Read-Host 'What is the path of computers? i.e. "c:\scripts\computernames.txt"'
$computers = Get-Content -Path $location

Write-Host "Found" + $computers

Foreach ($computer in $computers) {

Get-ADComputer -Identity $computer -Properties MemberOf | ForEach-Object {
  $_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Confirm:$false

  Write-Host "removing computer $computer from all groups"
}

}