<#
.Synopsis
   Get-MuCommandExcludingSomeModules
.EXAMPLE
   Get-MuCommandExcludingSomeModules vi
.EXAMPLE
   gcmx vi
#>
function Get-MuCommandExcludingSomeModules
{
    [CmdletBinding()]

    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Name

    )
    $Modules = Get-Module |
        where Name -NotMatch "^Az" |
        where Name -NotMatch "ISE"


    get-command -Module $Modules -Name "*$Name*"
}
set-alias gcmx Get-MuCommandExcludingSomeModules


