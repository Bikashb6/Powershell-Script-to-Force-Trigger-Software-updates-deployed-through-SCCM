#Remediation Script
#Resolve past due expired and pending verification issue for software update deployment.
#Resolve "past due expired" & "pending verification" issue for software update deployment.
$wmicheck=$null
$wmicheck =Get-WmiObject  -namespace root\cimv2 -Class Win32_BIOS -ErrorAction SilentlyContinue
New-EventLog -LogName Application -Source SyncStateScript -ErrorAction SilentlyContinue
if ($wmicheck){
        # Get list of all instances of CCM_SoftwareUpdate from root\CCM\ClientSDK for missing updates 
        $TargetedUpdates= Get-WmiObject  -Namespace root\CCM\ClientSDK -Class CCM_SoftwareUpdate -Filter ComplianceState=0
        $approvedUpdates= ($TargetedUpdates |Measure-Object).count
        $pendingpatches=($TargetedUpdates |Where-Object {$TargetedUpdates.EvaluationState -ne 8} |Measure-Object).count
        $rebootpending=($TargetedUpdates |Where-Object {$TargetedUpdates.EvaluationState -eq 8} |Measure-Object).count
        if ($pendingpatches -gt 0) {
                        try { 
                                $MissingUpdatesReformatted = @($TargetedUpdates | ForEach-Object {
                                if($_.ComplianceState -eq 0){[WMI]$_.__PATH}})
                                            
                                # The following is the invoke of the CCM_SoftwareUpdatesManager.InstallUpdates with our found updates  
                                $InstallReturn = Invoke-WmiMethod  -Class CCM_SoftwareUpdatesManager -Name InstallUpdates -ArgumentList (,$MissingUpdatesReformatted) -Namespace root\ccm\clientsdk     
                                Write-EventLog -LogName Application -Source SyncStateScript -EventId 666 -EntryType Information -Message “Targeted Patches :$approvedUpdates,Pending patches:$pendingpatches,Reboot Pending patches :$rebootpending,initiated $pendingpatches patches for install”  
  
                        } 
                        catch{
                            Write-EventLog -LogName Application -Source SyncStateScript -EventId 667 -EntryType Information -Message “pending patches – $pendingpatches but unable to install them ,please check Further” 
                        }
        }else{
 
            Write-EventLog -LogName Application -Source SyncStateScript -EventId 668 -EntryType Information -Message “Targeted Patches :$approvedUpdates,Pending patches:$pendingpatches,Reboot Pending patches :$rebootpending,Compliant”  
 }
 
}