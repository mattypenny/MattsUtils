function get-MuServerSize {
<#
.SYNOPSIS
Gets drive sizings - alias ss

#>
  [CmdletBinding()]

  Param( $ComputerName)

  foreach  ($C in $ComputerName)
  {
	Get-CimInstance -class Win32_LogicalDisk -filter "DriveType=3" -computer $C
  }
}
set-alias gs get-MuServerSize

function show-MuServerSize {
<#
.SYNOPSIS
Gets drive sizings and formats them
#>
[CmdletBinding()]

Param(     $ComputerName,
           [String] $Option = "0")

  $ComputerNameList = $ComputerName
  foreach ($ComputerName in $ComputerNameList)
  {

    if ($option -in 'default','def','0')
    {
      get-MuServerSize $ComputerName |
        Select SystemName,
              DeviceID,
              @{Name="%used";Expression={"{0:N1}" -f((($_.size - $_.freespace)/$_.size) * 100)}},
              VolumeName,
              @{Name="size(GB)";Expression={"{0:N1}" -f($_.size/1gb)}},
              @{Name="used(GB)";Expression={"{0:N1}" -f(($_.size - $_.freespace)/1gb)}},
              @{Name="freespace(GB)";Expression={"{0:N1}" -f($_.freespace/1gb)}} | ft -a
    }
    elseif ($option -in 'used','1')
    {
      get-MuServerSize $ComputerName |
        Select SystemName,
              DeviceID,
              @{Name="used(GB)";Expression={"{0:N1}" -f(($_.size - $_.freespace)/1gb)}},
              @{Name="size(GB)";Expression={"{0:N1}" -f($_.size/1gb)}} | ft -a

    }
    elseif ($option -in 'total','2','tot')
    {
      $TotalSizes =  get-MuServerSize $ComputerName | measure-object -sum size, freespace

      $Size = $($TotalSizes | Where-Object Property -eq 'size').sum
      $FreeSpace = $($TotalSizes | Where-Object Property -eq 'freespace').sum
      $UsedSpace = $Size - $FreeSpace

      $Size = [math]::Round($Size/1Gb)
      $FreeSpace = [math]::Round($FreeSpace/1Gb)
      $UsedSpace = [math]::Round($UsedSpace/1Gb)

      write-debug "`$Size: <$Size>"
      [PSCustomObject]@{
        ComputerName = $ComputerName
        SizeInGb = $Size
        FreeInGb = $FreeSpace
        UsedInGb = $UsedSpace
      }

    }
  }
}
set-alias ss show-MuServerSize

