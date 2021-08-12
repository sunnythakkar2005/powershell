$username = Read-Host "Enter Username"
$value = Read-Host "true or false"

if ($value -eq "true")
{
set-ADUser -Identity $username -ChangePasswordAtLogon $true
Write-Host "Setting Value true"
}
elseif($value -eq "false")
{
set-ADUser -Identity $username -ChangePasswordAtLogon $false
Write-Host "Setting Value false"
}
else
{
Write-Host "Make sure you type true or false"
}
