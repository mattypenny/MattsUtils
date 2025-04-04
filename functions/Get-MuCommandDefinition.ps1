function Get-MuCommandDefinition {
    <#
    .SYNOPSIS
        get the definition out of gcm (alias showme)
    #>
    [CmdletBinding()]
    param (
        $Command
    )

    foreach ($C in $(get-command "$Command")) {

        $RetrievedCommand = get-command $C

        [string]$Name = $RetrievedCommand.Name

        [string]$Definition = $RetrievedCommand.Definition

        [string]$Result =  @"
$Result
$Name`:

$Definition

"@

    }
    return $Result

}
set-alias gcmdef Get-MuCommandDefinition
set-alias showme Get-MuCommandDefinition

