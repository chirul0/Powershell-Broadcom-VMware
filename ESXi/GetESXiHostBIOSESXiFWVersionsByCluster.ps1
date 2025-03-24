$vcenter = Read-Host "Enter vCenter"
$credential = Get-Credential
Connect-VIServer $vcenter -Credential $credential #-AllLinked -Force #[Remove # before -AllLinked if working with multiple vCenters in linked mode]

Get-Cluster -PipelineVariable cluster |
  Foreach-Object -Process {
    Write-Host "## #####" $Cluster "##### ##"
     ForEach-Object -Process {
      $Cluster | Get-VMHost -PipelineVariable esx |
        ForEach-Object -Process {
          $esxcli = Get-EsxCli -VMHost $esx -V2
          $esxcli.network.nic.get.invoke( @{ nicname="vmnic0" }) | Select-Object @{ N = 'ESXi Host'; E = { $esx.Name }},
              #Comment out lines to exclude attributes from the report.
              @{N = 'Vendor'; E = { $esx.ExtensionData.Hardware.SystemInfo.Vendor }},
              @{N = 'Model'; E = { $esx.ExtensionData.Hardware.SystemInfo.Model }},
              @{N = 'Processors';E = { $esx.ExtensionData.Hardware.CpuInfo.NumCpuPackages }}, 
              @{N = 'BIOS Version'; E = { $esx.ExtensionData.Hardware.BiosInfo.BiosVersion }},
              @{N = 'Product'; E = { $esx.ExtensionData.Config.Product.Name }},
              @{N = 'ESXi Version'; E = { $esx.Version }},
              @{N = 'ESXi Build'; E = { $esx.Build }},
              @{N = 'NIC Driver'; E = { $_.DriverInfo.Version }},
              @{N = 'NIC FW Version'; E = { $_.DriverInfo.FirmwareVersion }},
              @{N = 'RAID FW Version'; E = { $esxcli.storage.san.sas.list.invoke().FirmwareVersion }} 
            }
      } | Sort-Object -Property "ESXi Host" | #Change Property value to sort by a different attribute
        Format-Table -AutoSize -Wrap 
    } 
