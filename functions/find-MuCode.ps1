function Find-MuCode {
    <#
.SYNOPSIS
    xx
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)][string]$Pattern,
        [Parameter(Mandatory = $False)][string]$Folder,
        [Parameter(Mandatory = $False)][switch]$OutputFull,
        [Parameter(Mandatory = $False)][switch]$OutputVeryShort,
        [Parameter(Mandatory = $False)][switch]$OutputShort,
        [Parameter(Mandatory = $False)][switch]$OutputNameOnly
    )
    DynamicParam {

        $options = @(
            (
                Import-Csv "$ENV:PSParametersFolder\GeneralParameters.csv" |
                    Where-Object Parameter -Like 'SearchPath-*' |
                    Group-Object -Property Parameter
            ).Name
        )

        New-DynamicParam -Name SearchPathCode -ValidateSet $options -Type string

    }
    begin {

        $SearchPathCode = $PSBoundParameters.SearchPathCode

    }
    process {
        $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

        if ($SearchPathCode) {
            write-dbg "`$SearchPathCode: <$SearchPathCode>"
            $Path = $(Import-Csv $Env:PSParametersFolder\GeneralParameters.csv | Where-Object Parameter -EQ $SearchPathCode).value
            foreach ($P In $Path) {
                write-dbg "`$P: <$P>"
            }
        }

        if ($Folder) {
            $Path = $Folder
        }

        write-dbg "`$Path: <$Path>"
        Write-Host "Will be searching $P...."

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

}

Set-Alias findmc Find-MuCode
Set-Alias finder Find-MuCode