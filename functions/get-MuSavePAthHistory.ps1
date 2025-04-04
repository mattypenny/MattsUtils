function get-MuSavePAthHistory {
    <#
    .SYNOPSIS
      Search through savepath history (alias hhh)
    #>
    [CmdletBinding()]
    Param ($Pattern = "*",
        $Tail = 50)

    [string]$HistoryFile = $(Get-PSReadLineOption).HistorySavePAth
    if ($Pattern -eq "*") {
        get-content -tail $Tail $HistoryFile
    }
    else {
        Select-string "$Pattern" $HistoryFile | select-object line
    }

}
Set-Alias -Name hhh -Value get-MuSavePAthHistory
