$assetNumber = Read-Host -Prompt "Type in AD Computer Name to upgrade"

write-host "`nCopying Files to Destination Computer`n"

# Copy 20H2 Files to Destination computer
Copy-Item -Path "\\nopshssccm01\SupportTools\Scripts\1909 script fix - onsite\*" -Destination ("\\" + $assetNumber + "\c$\Windows\ccmcache\") -Force

write-host "Finished copying Files!`n"

# Find out if the storage space is over 20GB
$storage = Get-CimInstance -ComputerName $assetNumber -ClassName Win32_Logicaldisk -filter "DeviceID='c:'" | 
    Select-Object PSComputername, @{Name="FreeGB";Expression={$_.Freespace / 1gb -as [int]}}

write-output "Current Disk Storage Available"
write-output $storage.FreeGB

write-host "Check if we have 20GB free storage and if not delete safe files to free up space`n"

if ($storage.FreeGB -le 20) {

    Invoke-Command -ComputerName $assetNumber -FilePath "C:\Windows\ccmcache\win10 PS Upgrade Script\Free Disk Storage.ps1"
}

$newStorage = Get-CimInstance -ComputerName $assetNumber -ClassName Win32_Logicaldisk -filter "DeviceID='c:'" | 
    Select-Object PSComputername, @{Name="FreeGB";Expression={$_.Freespace / 1gb -as [int]}}

# initate the WindowsUpdateBox and start installing 20H2 if there is 20GB of free space avail
if ($newStorage.FreeGB -le 20) {
    write-output "Need to contact user to manually free up user data. eg. documents, downloads, pictures, uninstall programs or videos"
    write-output $newStorage.FreeGB
    }
    else {

    Enter-PSSession -ComputerName $assetNumber


 }

