$assetNumber = Read-Host -Prompt "Type in AD Computer Name to upgrade"
$storage = 0

Function CheckFreeStorge ([string]$asset)
{

    $storage = Get-CimInstance -ComputerName $asset -ClassName Win32_Logicaldisk -filter "DeviceID='c:'" | 
    Select-Object PSComputername, @{Name="FreeGB";Expression={$_.Freespace / 1gb -as [int]}}

    Return $storage

}

Function DeleteStorage ([string]$asset)
{

    Invoke-Command -ComputerName $asset -ScriptBlock {
                try {
                        New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup' -Name StateFlags0001 -Value 2 -PropertyType DWord
                        New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\BranchCache' -Name StateFlags0001 -Value 2 -PropertyType DWord
                        $cleanmgr = Start-Process -FilePath "C:\Windows\System32\cleanmgr.exe" -ArgumentList '/verylowdisk'-WindowStyle Hidden -Wait
                        $cleanmgr1 = Start-Process -FilePath "C:\Windows\System32\cleanmgr.exe" -ArgumentList '/sagerun:1' -WindowStyle Hidden -Wait
                            if ($cleanmgr1) {
                                return "Clean Manager ran successfully!"

                                }
                            
                    }

               catch [System.Exception] {
                        return "Cleanmgr is not installed! To use this portion of the script you must install the following windows features:"
                        }

}

}


    write-host "Checking if we have 20GB free storage and if not delete safe files to free up space"

    # Find out if the storage space is over 20GB
    $storage = Get-CimInstance -ComputerName $assetNumber -ClassName Win32_Logicaldisk -filter "DeviceID='c:'" | 
    Select-Object PSComputername, @{Name="FreeGB";Expression={$_.Freespace / 1gb -as [int]}}

        if ($storage.FreeGB -le 50)
        {
        
            Write-Host "there is not enough storage. Running Free Disk Storage script if available or make sure there is atleast 20 gb free by contacting user"


            
            Invoke-Command -ComputerName $assetNumber -ScriptBlock {
                
                        New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup' -Name StateFlags0001 -Value 2 -PropertyType DWord;
                        New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\BranchCache' -Name StateFlags0001 -Value 2 -PropertyType DWord;
                        #$cleanmgr = Start-Process -FilePath "C:\Windows\System32\cleanmgr.exe" -ArgumentList '/verylowdisk'-WindowStyle Hidden -Wait
                        $cleanmgr1 = Start-Process -FilePath "C:\Windows\System32\cleanmgr.exe" -ArgumentList '/sagerun:1' -WindowStyle Hidden -Wait;
                        }
                         
                            
                      

                                $storagecheck = Get-CimInstance -ClassName Win32_Logicaldisk -filter "DeviceID='c:'" | Select-Object PSComputername, @{Name="FreeGB";Expression={$_.Freespace / 1gb -as [int]}}

                                 if ($storagecheck.FreeGB -le 20){

                                    Write-Host "Please contact user to clear space"

                                 }
                                 else
                                 {
                                 # Copy 20H2 Files to Destination computer

                                    
                                  <#  Write-Host "Copying installer"
                                    $Source = "\\nopshssccm01\SupportTools\Scripts\1909 script fix - onsite\*" 
                                    $Destination = ("\\" + $assetNumber + "\c$\Windows\ccmcache\")
                                    Start-BitsTransfer -Source $Source -Destination $Destination -Description "Windows 10 Upgrade " -DisplayName "Upgrade files"
                                    Write-Host "Now Run c:\windows\ccmcache\install.cmd"
                                    Enter-PSSession -ComputerName $assetNumber
                                    #>
                                    Write-Host "Copying installer"
                                    $Source = "\\nopshssccm01\SupportTools\Scripts\1909 script fix - onsite\*" 
                                    $Destination = ("\\" + $assetNumber + "\c$\Windows\ccmcache\")
                                    Start-BitsTransfer -Source $Source -Destination $Destination -Description "Windows 10 Upgrade " -DisplayName "Upgrade files"
                                    Write-Host "Now Running c:\windows\ccmcache\install.cmd"

                                    $remoteinst = "\Windows\ccmcache"
                                    $remotecomp = $assetNumber
                                    $remotedir = "C:" + $remoteinst + "\Install.cmd"
                                    Invoke-Command -ComputerName $remoteComp -ScriptBlock { & $using:remotedir }

                                 }

                                  


                                }

                                
                    

        


        else{
            <#
            # Copy 20H2 Files to Destination computer
            Write-Host "Copying installer"
            Copy-Item -Path "\\nopshssccm01\SupportTools\Scripts\1909 script fix - onsite\*" -Destination ("\\" + $assetNumber + "\c$\Windows\ccmcache\") -Force
            Write-Host "Now Run c:\windows\ccmcache\install.cmd"
            Enter-PSSession -ComputerName $assetNumber
            #>

            Write-Host "Copying installer"
            $Source = "\\nopshssccm01\SupportTools\Scripts\1909 script fix - onsite\*" 
            $Destination = ("\\" + $assetNumber + "\c$\Windows\ccmcache\")
            Start-BitsTransfer -Source $Source -Destination $Destination -Description "Windows 10 Upgrade " -DisplayName "Upgrade files"
            Write-Host "Now Running c:\windows\ccmcache\install.cmd"

            $remoteinst = "\Windows\ccmcache"
            $remotecomp = $assetNumber # Note: This syntax assumes that `ComputerName` is a *command*
            $remotedir = "C:" + $remoteinst + "\Install.cmd"
            Invoke-Command -ComputerName $remoteComp -ScriptBlock { & $using:remotedir }
            
        }


      



