function Find-MuCode {
<#
.SYNOPSIS
    xx
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)][string]$Pattern,
        [Parameter(Mandatory=$False)][string]$RepoShortName,
        [Parameter(Mandatory=$False)][string]$RepoFolder,
        [Parameter()][ValidateSet('top','me','repo','nsg')]$Where = 'me',
        [Parameter()][ValidateSet('short','veryshort','full','nameonly')]$Output = 'veryshort'
    )

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')


    $Path = switch ($Where) {
        'top' { $(import-csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -eq 'Fic-TopLevelFolder').value  }
        'repo' { $(import-csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -eq 'Fic-DefaultRepo').value  }
        'me' { $(import-csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -eq 'Fic-DefaultModuleEnv').value  }
        'nsg' { $(import-csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -eq 'Fic-DefaultNsg').value  }
        Default {}
    }

    if ($RepoFolder) {
        $Path = $repofolder
    }

    if ($RepoShortName) {
        $Path = $(import-csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -eq "Fic-${RepoShortName}").value
    }

    write-dbg "`$Path: <$Path>"

    $Hits = select-string -Pattern $Pattern -path $(get-childitem -Recurse $Path)

    switch ($Output) {
        'short' {
            $CutString =  $(import-csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -eq 'Fic-OutputShort').value
            write-host $CutString
            $Hits |
                select-object @{
                    Label = 'Fname'
                    Expression = {$_.path -replace $CutString,''}
                },
                    LineNumber,
                    Line
        }
        'VeryShort' {
            $CutString =  $(import-csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -eq 'Fic-OutputVeryShort').value
            $Hits |
                select-object @{
                    Label = 'Fname'
                    Expression = {$_.path -replace $CutString,''}
                },
                    LineNumber,
                    Line
        }
        'NameOnly' {
            $Hits |
                Select-Object Filename,
                    LineNumber,
                    Line
            }
        'Full' {
            $Hits
        }
        Default { $hits}
    }


}