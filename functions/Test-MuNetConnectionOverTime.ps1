function Test-MuNetConnectionOverTime {
  [CmdletBinding()]
  param (

      $ComputerName,
      $Count,
      $Noisy = $True

  )

  $Result = Test-MuNetConnectionAddMemberTime @PSBoundParameters

  [int]$SuccessfulPings = $($Result | Where-Object PingSucceeded -eq $True | Measure-Object).count

  [int]$FailedPings = $($Result | Where-Object PingSucceeded -ne $True | Measure-Object).count

  [int]$TotalPings = $($Result | Measure-Object).count

  [int]$SuccessfulPingTime = $($Result | Where-Object PingSucceeded -eq $True | Measure-Object -Sum -Property RoundTripTime).Sum

  [int]$FailedPingTime = $($Result | Where-Object PingSucceeded -ne $True | Measure-Object -Sum -Property RoundTripTime).Sum

  [int]$TotalPingTime = $($Result |  Measure-Object -Sum -Property RoundTripTime).Sum


  [PSCustomObject]@{
      ComputerName = $ComputerName
      SuccessfulPings = $SuccessfulPings
      FailedPings = $FailedPings
      TotalPings = $TotalPings
      SuccessfulPingTime = $SuccessfulPingTime
      FailedPingTime = $FailedPingTime
      TotalPingTime = $TotalPingTime

  }
}


