function Get-MuEventLog2 {
<#
.SYNOPSIS
    xx
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)][string[]]$ComputerName,
        [Parameter(Mandatory=$False)][datetime]$AroundTime = $(get-date),
        $LogName = 'system',
        $MinutesEitherSide = 5
    )

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

    $StartTime = $AroundTime.AddMinutes(-1 * $MinutesEitherSide)
    $EndTime = $AroundTime.AddMinutes($MinutesEitherSide)

    $Events = foreach ($C in $ComputerName) {

        invoke-command {Get-WinEvent -FilterHashtable @{ LogName = $using:LogName; StartTime = $using:StartTime ; EndTime = $using:EndTime }}  -computername $C | Select-Object -First 1
    }

    $events | select timecreated,pscomputername,EventDesc,id,message

}
