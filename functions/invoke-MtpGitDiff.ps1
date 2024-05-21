function invoke-MtpGitDiff {
<#
.SYNOPSIS
    xx
#>
    [CmdletBinding()]
    param (
        [string]$Folder = $(get-location)
    )
    
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
    
    write-startfunction

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

    write-endfunction
    
    
}
set-alias gitdiff invoke-MTPGitDiff


