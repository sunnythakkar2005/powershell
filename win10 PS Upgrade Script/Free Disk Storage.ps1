<# Need to test if permissions is required first
takeown /F C:\Windows.old* /R /A /D Y
cacls C:\Windows.old*.* /T /grant administrators:F
rmdir /S /Q C:\Windows.old
#>

# Deletes 90% of windows.old files
$drive = (Get-Partition | Where-Object { ((Test-Path ($_.DriveLetter + ':\Windows.old')) -eq $True)}).DriveLetter


If ((Test-Path ($drive + ':\Windows.old')) -eq $true) {
    $Directory = $Drive + ':\Windows.old'
    cmd.exe /c rmdir /S /Q $Directory
    }

# Deletes 90% of softwaredistribution.old
$drive = (Get-Partition | Where-Object { ((Test-Path ($_.DriveLetter + ':\windows\softwaredistribution.old')) -eq $True)}).DriveLetter

If ((Test-Path ($drive + ':\windows\softwaredistribution.old')) -eq $true) {
    $Directory = $Drive + ':\windows\softwaredistribution.old'
    cmd.exe /c rmdir /S /Q $Directory
    }


# Deletes ccmcache folder 
$resman= New-Object -ComObject "UIResource.UIResourceMgr"
$cacheInfo=$resman.GetCacheInfo()
$cacheinfo.GetCacheElements() | foreach {
    $cacheInfo.DeleteCacheElement($_.CacheElementID)
    }

# Display Diskspace
write-output "New Disk storage Information"
write-output -----------------------
fsutil volume diskfree c:


# Disable hibernate file
$hibernate = Read-Host -Prompt 'Do you want to disable hibernation for more storage? [Y] for yes [N] for no'

if ($hibernate -eq "Y" -or $hibernate -eq "Yes") {
    powercfg.exe /hibernate OFF
    write-output 'hiberfil.sys file has been deleted'
    }
    else {
    write-output 'no setting was changed'
    }
