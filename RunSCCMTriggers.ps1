Function Run-SCCMClientAction {
        [CmdletBinding()]
                
        # Parameters used in this function
        param
        ( 
            [Parameter(Position=0, Mandatory = $True, HelpMessage="Provide server names", ValueFromPipeline = $true)] 
            [string[]]$Computername,
 
           [ValidateSet('MachinePolicy', 
                        'DiscoveryData', 
                        'ComplianceEvaluation', 
                        'AppDeployment',  
                        'HardwareInventory', 
                        'UpdateDeployment', 
                        'UpdateScan', 
                        'SoftwareInventory')] 
            [string[]]$ClientAction
   
        ) 
        $ActionResults = @()
        Try { 
                $ActionResults = Invoke-Command -ComputerName $Computername {param($ClientAction)
 
                        Foreach ($Item in $ClientAction) {
                            $Object = @{} | select "Action name",Status
                            Try{
                                $ScheduleIDMappings = @{ 
                                    'MachinePolicy'        = '{00000000-0000-0000-0000-000000000021}'; 
                                    'DiscoveryData'        = '{00000000-0000-0000-0000-000000000003}'; 
                                    'ComplianceEvaluation' = '{00000000-0000-0000-0000-000000000071}'; 
                                    'AppDeployment'        = '{00000000-0000-0000-0000-000000000121}'; 
                                    'HardwareInventory'    = '{00000000-0000-0000-0000-000000000001}'; 
                                    'UpdateDeployment'     = '{00000000-0000-0000-0000-000000000108}'; 
                                    'UpdateScan'           = '{00000000-0000-0000-0000-000000000113}'; 
                                    'SoftwareInventory'    = '{00000000-0000-0000-0000-000000000002}'; 
                                }
                                $ScheduleID = $ScheduleIDMappings[$item]
                                Write-Verbose "Processing $Item - $ScheduleID"
                                [void]([wmiclass] "root\ccm:SMS_Client").TriggerSchedule($ScheduleID);
                                $Status = "Success"
                                Write-Verbose "Operation status - $status"
                            }
                            Catch{
                                $Status = "Failed"
                                Write-Verbose "Operation status - $status"
                            }
                            $Object."Action name" = $item
                            $Object.Status = $Status
                            $Object
                        }
 
            } -ArgumentList $ClientAction -ErrorAction Stop | Select-Object @{n='ServerName';e={$_.pscomputername}},"Action name",Status
        }  
        Catch{
            Write-Error $_.Exception.Message 
        }   
        Return $ActionResults           
 } 