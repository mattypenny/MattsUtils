<#
.SYNOPSIS
   Shows all the reboots recorded in the eventlog
.DESCRIPTION
  Derived from:
    https://social.technet.microsoft.com/wiki/contents/articles/17889.powershell-script-for-Muutdownreboot-events-tracker.aspx

#>
function Get-MuPreviousReboots {
  [CmdletBinding()]
  param (
      [string[]]$ComputerName = "."
  )

  $ListOfComputerNames = $ComputerName
  [string]$ComputerName = ""

  $PreviousReboots = @()

  foreach ($ComputerName in $ListOfComputerNames) {

      $WinEvents = Get-WinEvent -ComputerName $ComputerName -FilterHashtable @{logname='System'; id=1074}

      foreach ($W in $WinEvents) {

          $Properties = $W.Properties

          $PreviousReboots += [PSCustomObject]@{
              ComputerName = $ComputerName
              Date = $W.TimeCreated
              User = $Properties[6].Value
              Process = $Properties[0].Value
              Action = $Properties[4].Value
              Reason = $Properties[2].Value
              ReasonCode = $Properties[3].Value
              Comment = $Properties[5].Value
          }

      }


  }

  $PreviousReboots | Sort-Object -Property date -Descending

}

