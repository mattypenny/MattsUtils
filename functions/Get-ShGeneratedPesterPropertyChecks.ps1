function Get-ShGeneratedPesterPropertyChecks {
    [CmdletBinding()]
    param (
        [string[]]$ObjectName,
        # $Object,
        $Property
    )
    
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
    
    write-startfunction
    
    $ListOfProperties = $Property

    $Result = ""
    foreach ($property in $ListOfProperties) {

        $Result = @"
$Result
[String]`$$Property = `$$ObjectName.$Property
`$$Property | Should Be 'xx'

"@
        

    }

    write-endfunction
    
    $Result
    
}

