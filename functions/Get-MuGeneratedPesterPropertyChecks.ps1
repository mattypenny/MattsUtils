function Get-MuGeneratedPesterPropertyChecks {
    <#
    .SYNOPSIS
        Generate pester should be's for each property of a specified object
    #>
    [CmdletBinding()]
    param (
        [string[]]$ObjectName,
        # $Object,
        $Property
    )

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')


    $ListOfProperties = $Property

    $Result = ""
    foreach ($property in $ListOfProperties) {

        $Result = @"
$Result
[String]`$$Property = `$$ObjectName.$Property
`$$Property | Should Be 'xx'

"@


    }


    $Result

}

