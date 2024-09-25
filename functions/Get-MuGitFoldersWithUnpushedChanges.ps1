function Get-MuGitFoldersWithUnpushedChanges {
<#
.SYNOPSIS
    look for unpushed files in git folders
#>
    [CmdletBinding()]
    param (
        $ParameterFile = "$env:PsParametersFolder\GeneralParameters.csv"
    )

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')


    $RootFolders = import-csv -path $ParameterFile |
        where-object Program -eq 'Get-FoldersWithUnpushedChanges' |
        where-object Parameter -eq 'RootFolders'

    $ExcludePatterns = import-csv -path $ParameterFile |
        where-object Program -eq 'Get-FoldersWithUnpushedChanges' |
        where-object Parameter -eq 'ExcludePatterns'

    $GitFolders = foreach ($F in $RootFolders) {

        $Fullname = $F.Value

        get-childitem $Fullname -Directory -recurse .git -force

    }

    $IncludedFolders = foreach ($C in $GitFolders) {

        $Fullname = $C.Fullname
        $Fullname = [System.IO.Path]::GetDirectoryName($Fullname)

        $MatchesExcludePattern = $False
        foreach ($E in $ExcludePatterns) {

            $ExcludePattern = $E.Value
            if ($Fullname -like "$ExcludePattern") {

                $MatchesExcludePattern = $True

            }

        }

        if (!($MatchesExcludePattern)) {

            $Fullname

        }

    }

    # Todo - the git stuff

    $OriginalLocation = get-location
    $DirtyFileFullNames = foreach ($F in $IncludedFolders) {

        set-location $F
        write-dbg "`$F: <$F>"
        $DirtyFileLines = git status --porcelain

        foreach ($D in $DirtyFileLines) {
            write-dbg "`$D: <$D>"
            $DirtyFile = $D.substring(3,($D.length - 3))
            $DirtyFile = $DirtyFile.trim()

            $Fullname = join-path $F $DirtyFile

            $FullName
        }

    }

    $DirtyFileFullNames

    set-location $OriginalLocation



}

set-alias ggacall Get-MuGitFoldersWithUnpushedChanges


