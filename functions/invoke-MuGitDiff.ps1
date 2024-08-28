function invoke-MuGitDiff {
<#
.SYNOPSIS
    Git diff for all the files in a folder
#>
    [CmdletBinding()]
    param (
        [string]$Folder = $(get-location)
    )

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')


    foreach ($F in $(get-childitem $Folder)) {

        $Gitdiff = git diff $F

        if ($Gitdiff) {

            [string]$Name = $F.Name
            write-host -foregroundcolor Yellow "========================================="
            write-host -foregroundcolor Yellow "$Name"
            write-host -foregroundcolor Yellow "========================================="

            git diff $F
        }

    }



}
set-alias gitdiff invoke-MuGitDiff


