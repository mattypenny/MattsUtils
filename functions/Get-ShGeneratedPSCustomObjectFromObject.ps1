function Get-ShGeneratedPSCustomObjectFromObject {
    [CmdletBinding()]
    param (
        $InputObject,
        $RightHandSidePrefix
    )
    
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
    
    write-startfunction
    
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


    write-endfunction
    
    return $Text
}


