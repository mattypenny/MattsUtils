function get-MuHistory {
    <#
    .SYNOPSIS
      Search through history (alias hh)
    #>
    [CmdletBinding()]
    Param ($Pattern = "*",
        $Tail = 50)

    if ($Pattern -eq "*") {
        Get-History -count $Tail |  select Commandline
    }
    else {
        Get-History | Where-Object CommandLine -like "*$Pattern*" | select Commandline
    }

}
Set-Alias -Name hh -Value get-MuHistory

