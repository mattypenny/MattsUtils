function get-MTPGitStatusAsObjects
{
    [CmdletBinding()]
     Param
    (

    )

    $GitStatusAsString = git status -s

    $GitStatusAsSeperateLines = $GitStatusAsString | Select-String '^'


    $GitStatusAsObjects = @()
    foreach ($G in $GitStatusAsSeperateLines) {

        [string]$Line = $G.Line

        [string]$Status = $Line.Substring(0,2)

        $Status = $Status.Trim()

        $Filename = $Line.Substring(3, ($Line.Length-3))

        $GitStatusAsObjects += [PSCustomObject]@{
            Status = $Status
            Filename = $Filename
        }

    }

    $GitStatusAsObjects

}

set-alias ggac get-MTPgitaddandRemoveCommands

