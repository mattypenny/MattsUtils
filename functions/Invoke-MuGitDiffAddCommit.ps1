function Invoke-MuGitDiffAddCommit {
    <#
    .SYNOPSIS
        Git diff, add, commit and push for each file in a folder (alias gdac)
    #>

    [CmdletBinding()]

    Param
    (
        [Parameter(Position = 0)]
        $FileName
    )

    git diff $Filename

    $Continue = Read-Host -Prompt "git add?"

    if ($Continue -eq 'y') {

        git add $Filename

        $CommitMessage = Read-Host -Prompt "git message?"

        $Continue = Read-Host -Prompt "Happy with that?"

        if ($Continue -eq 'y') {

            git commit -m $CommitMessage

            $Continue = Read-Host -Prompt "Push it...push it good?"
            if ($Continue -eq 'y') {

                git push

            }

        }

    }



}
set-alias gdac Invoke-MuGitDiffAddCommit