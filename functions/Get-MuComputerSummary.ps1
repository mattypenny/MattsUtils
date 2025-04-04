function get-MuComputerSummary
{
<#
.SYNOPSIS
  Get summary for specified computer (alias sos)
.DESCRIPTION

#>

  [CmdletBinding()]
  Param (
    [string[]]$ComputerName = ".",
    [string]$ExportFolder
  )

  foreach ($C in $ComputerName)
  {

      write-dbg "Processing Computer <$c>"
      try
      {
        $OS = Get-CimInstance -class win32_operatingsystem -computer $C -ErrorAction Stop
        write-dbg "Got OS"
      }
      catch
      {
        write-dbg "In OS catch"
        $OS = [PSCustomObject]@{
          __Server = $C
          Caption = "Not retrieved"
          InstallDate = "00000000000000.000000+000"
          LastBootUpTime = "00000000000000.000000+000"
          TotalVisibleMemorySize = 0
          FreePhysicalMemory = 0
        }
      }
      try
      {
        $Disk = get-ciminstance -class Win32_LogicalDisk -filter "DriveType=3" -computer $C -ErrorAction Stop |
          measure-object -property size -sum

      }
      catch
      {
        $Disk = [PSCustomObject]@{
          Sum = 0
        }
      }

      [string]$VersionString = $OS.Caption

      [string]$RegisterMark = [char]174
      $VersionString = $VersionString.replace($RegisterMark,'')
      $VersionString = $VersionString.replace('Microsoft Windows ','').replace('Microsoft(R) Windows(R) ','Windows')


      [string]$InstallDateString = $OS.InstallDate
      $InstallDateString = $InstallDateString.substring(0,10)

      [string]$LastBootupTimeString = $OS.LastBootUpTime


      $TotMemGb = $OS.TotalVisibleMemorySize/1Mb
      $TotMemGb = "{0:N1}" -f $TotMemGb

      $FreeMemGb = $OS.FreePhysicalMemory/1Mb
      $FreeMemGb = "{0:N1}" -f $FreeMemGb

      $TotalDisk = $Disk.Sum/1Gb
      $TotalDisk = "{0:N1}" -f $TotalDisk

      [PSCustomObject]@{
          Server = $C
          Caption = $VersionString
          SPMaj = $OS.ServicePackMajorVersion
          SPMin = $OS.ServicePackMinorVersion
          Version = $OS.Version
          TotMemGb = $TotMemGb
          FreeMemGb = $FreeMemGb
          TotDiskGb = $TotalDisk
          Installed = $InstallDateString
          Booted = $LastBootUpTimeString
      }
    }




}



function sos {
  [CmdletBinding()]
  Param ( [Parameter(Position=1)]$ComputerName = ".")

  get-MuComputerSummary $ComputerName | ft -a

}



