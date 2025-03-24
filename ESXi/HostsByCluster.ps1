$vcenter = Read-Host "Enter vCenter"
$credential = Get-Credential
Connect-VIServer $vcenter -Credential $credential #-AllLinked -Force [Remove # if using multiple vCenters in linked mode]

$Clusters = Get-Cluster
  
  foreach ($Cluster in $Clusters) {
  
    Write-Host "## #####" $Cluster "##### ##"
    $Cluster | Get-VMHost | 
    Select-Object @{Label = "Host"; Expression = { $_.Name }} | 
    Sort-Object -Property Host | 
    Format-Table -AutoSize -Wrap

  }
