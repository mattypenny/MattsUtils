function invoke-MuPesterLoop {
<#
.SYNOPSIS
  Continuously run pester tests. Output green do if all OK. Display errpr of not.
#>
  [CmdletBinding()]
  param (
    $Script,
    $Hours
  )

  $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')


  $Iterations = $Hours * 12

  for ($i = 0; $i -lt $Iterations; $i++) {

    write-dbg "About to: invoke-pester $Script -passthru *> l:\temp\invoke-PesterLoop.txt"
    $ResultsObject = invoke-pester $Script -passthru *> l:\temp\invoke-PesterLoop.txt
    $ResultsObjectCount = $( $ResultsObject | measure-object).count
    write-dbg "`$ResultsObjectCount: <$ResultsObjectCount>"

    $FailedCount = $ResultsObject.FailedCount
    write-dbg "`$FailedCount: <$FailedCount>"

    if ($FailedCount -gt 0) {

      $Failures = $ResultsObject | Select-Object -ExpandProperty TestResult | Where-Object Passed -eq $False
      $FailuresCount = $( $Failures | measure-object).count
      write-dbg "`$FailuresCount: <$FailuresCount>"

      foreach ($F in $Failures) {

        $Describe = $F.Describe
        $FailureMessage = $F.FailureMessage
        $Name = $F.Name

        write-output "$Describe"
        write-output "$Name"
        write-output "$FailureMessage"

      }

    } else {
      write-host -ForegroundColor  Green '.' -NoNewline
    }

  }



}


