function Get-MuAdGroup {
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

    $Groups = get-ADGroup -filter "Name -like '*$GroupString*'" -properties *


    if ($ShowAll) {
        $Groups
    } elseif ($ShowMembers) {
        "Not coded yet"
    } else {
        $Groups | select name, distinguishedname, created
    }

}
set-alias Get-MadGroup Get-MuAdGroup
