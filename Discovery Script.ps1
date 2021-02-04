#Discovery script
$wmicheck=$null
#Check whether WMI is accessible
$wmicheck =Get-WmiObject -namespace root\cimv2 -Class Win32_BIOS -ErrorAction SilentlyContinue
if ($wmicheck)
{
        # Get list of all instances of CCM_SoftwareUpdate from root\CCM\ClientSDK for missing updates
        $TargetedUpdates= Get-WmiObject -Namespace root\CCM\ClientSDK -Class CCM_SoftwareUpdate -Filter ComplianceState=0
        $approvedUpdates= ($TargetedUpdates |Measure-Object).count
        $pendingpatches=($TargetedUpdates |Where-Object {$TargetedUpdates.EvaluationState -ne 8} |Measure-Object).count
        $rebootpending=($TargetedUpdates |Where-Object {$TargetedUpdates.EvaluationState -eq 8} |Measure-Object).count
        if ($pendingpatches -gt 0){
                        
                            Return(1)
        }
        else {Return(0) }
}