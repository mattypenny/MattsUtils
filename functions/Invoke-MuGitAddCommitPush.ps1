function Invoke-MuGitAddCommitPush {
    <#
    .SYNOPSIS
        Add, commit with a message per file and push (alias ggacx)
    #>

        [CmdletBinding()]

        Param
        (
            [Parameter(Position = 0)]
            $FolderName = "."
        )

        cd $FolderName

        $GitStatusAsObjects = get-MuGitStatusAsObjects

        foreach ($G in $($GitStatusAsObjects | Where-Object Status -ne 'D')) {

            [string]$Filename = $G.Filename

            git diff $Filename

            $Continue = Read-Host -Prompt "git add?"

            if ($Continue -eq 'y') {

                git add $Filename

                $CommitMessage = Read-Host -Prompt "git message?"

                $Continue = Read-Host -Prompt "git commit and push?"

                if ($Continue -eq 'y') {


                    git commit -m $CommitMessage
                    git push

                }


            }

        }


}
set-alias ggacx Invoke-MuGitAddCommitPush

