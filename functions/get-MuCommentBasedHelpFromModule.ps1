function get-MuCommentBasedHelpFromModule {
    <#
    .Synopsis
    Get all the help for all the functions in specified modules
    #>
    [CmdletBinding()]
    param (
        $Module
    )

    $Help = @()

    $ListOfModules = $Module
    foreach ($M in $ListOfModules) {

        [string]$Module = $M

        $CommandsInModule= get-command -module $Module

        foreach ($C in $CommandsInModule) {

            [string]$Command = $C.Name

            $Help += get-help -full $Command

        }

    }

    $Help
}

