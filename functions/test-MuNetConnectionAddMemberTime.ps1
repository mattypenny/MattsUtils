function Test-MuNetConnectionAddMemberTime {
    [CmdletBinding()]
    param (
        $ComputerName,
        $Count,
        $Noisy = $True
    )

    $T=@()
    for ($i = 0; $i -lt $Count; $i++) {

        $Result = test-netconnection -ComputerName $ComputerName -InformationLevel Detailed

        $PingReplydetails = $Result | select -ExpandProperty PingReplydetails

        [int]$RoundTripTime = $PingReplydetails.RoundTripTime
        $Result | add-member -Name RoundTripTime -Value $RoundTripTime -MemberType NoteProperty

        $T += $Result

        if ($Noisy) {

            [string]$ComputerName = $Result.ComputerName
            # [string]$SourceAddress = $Result.SourceAddress
            [string]$RemoteAddress = $Result.RemoteAddress
            [string]$PingSucceeded = $Result.PingSucceeded
            [string]$RoundtripTime = $Result.RoundtripTime

            if ($PingSucceeded -eq "False") {
                $ForegroundColour = "Magenta"
            }
            else {
                $ForegroundColour = "Green"
            }

            write-host -ForegroundColor $ForegroundColour "$ComputerName $SourceAddress $RemoteAddress $PingSucceeded $RoundtripTime"
        }

    }
    $T
  }

