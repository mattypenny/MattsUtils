function Get-ShGeneratedDescribesForEachFunction {
<#
.SYNOPSIS
    Generate pester describes...not sure if it's very useful
#>
    [CmdletBinding()]
    param (
        $NameString,
        $Module    # not coded yet!
    )

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

    write-startfunction

    $Functions = get-command $NameString

    $ReturnString = ""
    foreach ($F in $Functions) {

        [string]$Name = $F.Name

        $SplatString = get-ShGeneratedSplatLines $Name

        $ReturnString = @"
$ReturnString
Describe "$Name" {

    $SplatString

    It "xx" {

    }

}

"@
    }

    write-endfunction

    $ReturnString

}

