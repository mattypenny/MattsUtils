function get-ShCommandFromSpecifiedModules {
    <#
    .SYNOPSIS
        Get command for one module, defaulting to dbatools
    #>
    [CmdletBinding()]

    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Name,
        [string[]]$Module = ('dbatools')
    )

    get-command -module $Module -name "*$Name*"

}

Set-Alias gcmd get-ShCommandFromSpecifiedModules
Set-Alias gcmdba get-ShCommandFromSpecifiedModules

