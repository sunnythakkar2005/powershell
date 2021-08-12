$pcname = Read-Host -Prompt 'Enter PC Name'
Invoke-Command -ComputerName $pcname {
$cmd1 = "cmd.exe"
$arg1 = "/c"
$arg2 = "echo y | gpupdate /force /wait:0"
&$cmd1 $arg1 $arg2
}
