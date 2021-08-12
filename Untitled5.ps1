Invoke-Command -ComputerName HCA1030042 -Credentials $cred4 -ScriptBlock {
        Start-Process -FilePath "C:\Windows\regedit.exe" -ArgumentList "/s C:\users\hayley_new\Desktop\hctrans.reg"
    }