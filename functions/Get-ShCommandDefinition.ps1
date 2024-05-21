function Get-ShCommandDefinition {
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
set-alias gcmdef Get-ShCommandDefinition
set-alias showme Get-ShCommandDefinition

