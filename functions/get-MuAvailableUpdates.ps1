function get-MuAvailableUpdates {
<#
.SYNOPSIS
    One-line description
.DESCRIPTION
    Longer description
.PARAMETER

.EXAMPLE
    Example of how to use this cmdlet
#>
    [CmdletBinding()]
    Param
        (
            [string]$ComputerName
        )

    $ListOfComputerNames = $ComputerName

    foreach ($ComputerName in $ListOfComputerNames)
    {
        $SearchResult = Invoke-Command -ComputerName $ComputerName -ScriptBlock {

            $Criteria = "IsInstalled=0 and Type='Software'"
            $Searcher = New-Object -ComObject Microsoft.Update.Searcher
            $Searcher.Search($Criteria).Updates

        }

        $SearchResult | select lastdeploymentchangetime, isdownloaded, isinstalled, maxdownloadsize, type, rebootrequired, title

    }


}

