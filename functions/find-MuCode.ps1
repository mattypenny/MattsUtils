function Find-MuCode {
    <#
.SYNOPSIS
    xx
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)][string]$Pattern,
        [Parameter(Mandatory = $False, ParameterSetName = 'FolderCode')][string]$FolderCode,
        [Parameter(Mandatory = $False, ParameterSetName = 'Folders')][string]$Folder,
        [Parameter(Mandatory = $False, ParameterSetName = 'ManyFoldersCode')][ValidateSet('AllRepos', 'MyBits', 'DefaultRepo', 'nsg', 'Island')]$ManyFoldersCode = 'MyBits',
        [Parameter(Mandatory = $False)][switch]$OutputFull,
        [Parameter(Mandatory = $False)][switch]$OutputVeryShort,
        [Parameter(Mandatory = $False)][switch]$OutputShort,
        [Parameter(Mandatory = $False)][switch]$OutputNameOnly
    )

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')


    $Path = switch ($ManyFoldersCode) {
        'AllRepos' {
            $(Import-Csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -EQ 'Fic-TopLevelFolder').value
        }
        'DefaultRepo' {
            $(Import-Csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -EQ 'Fic-DefaultRepo').value
        }
        'MyBits' {
            $(Import-Csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -EQ 'Fic-DefaultModuleEnv').value
        }
        'Nsg' {
            $(Import-Csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -EQ 'Fic-DefaultNsg').value
        }
        'Island' {
            $(Import-Csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -EQ 'Fic-Island').value
        }
        Default {
        }
    }

    if ($Folder) {
        $Path = $Folder
    }

    if ($FolderCode) {
        $Path = $(Import-Csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -EQ "Fic-${FolderCode}").value
    }

    write-dbg "`$Path: <$Path>"

    $Hits = Select-String -Pattern $Pattern -Path $(Get-ChildItem -Recurse $Path)

    if ($OutputShort) {
        $CutString = $(Import-Csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -EQ 'Fic-OutputShort').value
        Write-Host $CutString
        $Hits |
            Select-Object @{
                Label      = 'Fname'
                Expression = { $_.path -replace $CutString, '' }
            },
            LineNumber,
            Line
    }
    elseif ($OutputVeryShort) {
        $CutString = $(Import-Csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -EQ 'Fic-OutputVeryShort').value
        $Hits |
            Select-Object @{
                Label      = 'Fname'
                Expression = { $_.path -replace $CutString, '' }
            },
            LineNumber,
            Line
    }
    elseif ($OutputNameOnly) {
        $Hits |
            Select-Object Filename,
            LineNumber,
            Line
    }
    else {
        $Hits |
            Select-Object Path,
            LineNumber,
            Line
    }


}

Set-Alias findmc Find-MuCode
Set-Alias finder Find-MuCode