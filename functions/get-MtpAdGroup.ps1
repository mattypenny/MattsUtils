function Get-MtpAdGroup {
<#
.SYNOPSIS
    Group names matching string
#>
    [CmdletBinding()]
    param (
        [string]$GroupString,
        [switch]$ShowAll = $false,
        [switch]$ShowMembers = $False

    )

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

    write-startfunction

    $Groups = get-ADGroup -filter "Name -like '*$GroupString*'" -properties *

    if ($ShowAll) {
        $Groups
    } elseif ($ShowMembers) {
        "Not coded yet"
    } else {
        $Groups | select name, distinguishedname, created
    }



    write-endfunction


}
set-alias Get-MadGroup Get-MtpAdGroup