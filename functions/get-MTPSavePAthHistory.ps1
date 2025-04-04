function get-MTPSavePAthHistory {
    <#
    .SYNOPSIS
      Search through history
    #>
    [CmdletBinding()]
    Param ($Pattern = "*",
        $Tail = 50)

    [string]$HistoryFile = $(Get-PSReadLineOption).HistorySavePAth
    if ($Pattern -eq "*") {
        get-content -tail $Tail 
    }
    else {
        Select-string "$Pattern" $HistoryFile | select-object line
    }

}
Set-Alias -Name hhh -Value get-MTPSavePAthHistory

