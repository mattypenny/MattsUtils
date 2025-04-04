function Get-MuGeneratedDescribesForEachFunction {
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


    $Functions = get-command $NameString

    $ReturnString = ""
    foreach ($F in $Functions) {

        [string]$Name = $F.Name

        $SplatString = get-MuGeneratedSplatLines $Name

        $ReturnString = @"
$ReturnString
Describe "$Name" {

    $SplatString

    It "xx" {

    }

}

"@
    }


    $ReturnString

}

