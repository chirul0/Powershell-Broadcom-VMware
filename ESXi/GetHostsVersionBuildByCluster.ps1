# Prints ESXi hosts by cluster with ESXi Version and Build

$vcenter = Read-Host "Enter vCenter"
$credential = Get-Credential
Connect-VIServer $vcenter -Credential $credential #-AllLinked -Force #[Remove # before -AllLinked if working with multiple vCenters in linked mode]
$Clusters = Get-Cluster
foreach ($Cluster in $Clusters)
{
Write-Host "## #####" $Cluster "##### ##"
$Cluster | Get-VMHost | Select-Object @{Label = "Host"; Expression = {$_.Name}},
@{Label = "ESX Version"; Expression = {$_.version}},
@{Label = "ESX Build" ; Expression = {$_.build}} | 
Sort-Object -Property Host | 
Format-Table -AutoSize -Wrap
}
