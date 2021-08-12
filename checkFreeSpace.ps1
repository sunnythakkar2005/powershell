$pcname = $args[0]
Get-CimInstance -ComputerName $pcname -ClassName Win32_Logicaldisk -filter "DeviceID='c:'" | Select-Object PSComputername, @{Name="FreeGB";Expression={$_.Freespace / 1gb -as [int]}}