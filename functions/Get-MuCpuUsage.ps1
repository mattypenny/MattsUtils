function get-MuCpuUsage {
<#
.SYNOPSIS
  Show CPU usage over specified intervals
#>
Param ( $ComputerName = ".",
        [Int] $MyDelay = 0,
        [Int] $MyCount = 1)

# if Delay and count are not specified, then do it immediately and just once.
for ($i = 0 ; $i -le $MyCount - 1 ; $i++ )
{
    foreach ($C in $ComputerName)
    {
        $MY_TIME = get-date
        $MY_PERF = Get-CimInstance win32_processor -computer $C
        $MY_PERF | add-member -MemberType NoteProperty -Name MyTime -Value $MY_TIME
        $MY_PERF | select MyTime, SystemName, SocketDesignation, LoadPercentage
        # write-host $MY_TIME, $MY_PERF.SystemName, $MY_PERF.SocketDesignation, $MY_PERF.LoadPercentage
        start-sleep -s $MyDelay
    }
}

}
set-alias cpu get-MuCpuUsage

