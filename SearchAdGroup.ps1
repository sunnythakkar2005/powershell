<#
    Excample usage:

    .\SearchAdGroup.ps1 'SW-Meth'

#>
$searchstring = $args[0]
Get-ADGroup -Filter '*' | where-object {$_.distinguishedname -like "*$searchstring*"}  | select name
