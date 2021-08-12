$obj = Get-ADComputer NCA1030542
Add-ADGroupMember -ID 'SW-Methode Client Suite 610B9F_5' -Members $obj
