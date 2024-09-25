function Get-MuGeneratedPSCustomObjectFromObject {
    <#
    .SYNOPSIS
        Generate a [PSCustomObject] for a specified object
    #>
    [CmdletBinding()]
    param (
        $InputObject,
        $RightHandSidePrefix
    )

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')


    $Members = $InputObject | Get-Member | ? MemberType -like "*Property"

    $Text = @"
[PSCustomObject]@{
"@

    foreach ($M in $Members) {
        [string]$Name = $M.Name

        $Text = @"
$Text
    $Name = `$$RightHandSidePrefix.$Name
"@
    }

    $Text = @"
$Text
}
"@



    return $Text
}


