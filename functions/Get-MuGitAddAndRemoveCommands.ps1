function Get-MuGitAddAndRemoveCommands {
<#
.Synopsis
Generates a 'git add' or 'git rm' commands for folder
.DESCRIPTION
.EXAMPLE
ggac

git add .gitignore function-convertto-twiki.ps1 function-edit-powershellref.ps1 function-get-gitaddcommand.ps1

#>
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter(Position = 0)]
        $FolderName = "."
    )

    cd $FolderName

    $GitStatusAsObjects = get-MuGitStatusAsObjects

    foreach ($G in $($GitStatusAsObjects | Where-Object Status -ne 'D')) {

        [string]$Filename = $G.Filename

        Write-Output "git diff $Filename"

    }

    foreach ($G in $($GitStatusAsObjects | Where-Object Status -ne 'D')) {

        [string]$Filename = $G.Filename

        Write-Output "git add $Filename"

    }

    foreach ($G in $($GitStatusAsObjects | Where-Object Status -eq 'D')) {

        [string]$Filename = $G.Filename

        Write-Output "git rm $Filename"

    }
}


