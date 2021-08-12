<#
    Excample usage:

    AddGroupComputer.ps1 NCA1030542 'SW-Methode Client Suite 610B9F_5'

#>
$computername = $args[0]
$adgroup = $args[1]

Add-ADGroupMember -ID $adgroup -Members (Get-ADComputer $computername).distinguishedname