function select-MuStringsFromCode {

 

    <#

 

.SYNOPSIS

    Searches for code in files specified in $Env:PsParametersFolder\GeneralParameters.csv





    #>

    [CmdletBinding()]

 

    param ($SearchString,

        $IncludedFolders = $(import-csv $Env:PsParametersFolder\GeneralParameters.csv | Where-Object Parameter -eq 'Sfs-IncludedFolders').value,

        $ExcludedPatterns = $(import-csv $Env:PsParametersFolder\GeneralParameters.csv | Where-Object Parameter -eq 'Sfs-ExcludedPatterns').value

    )

 

    write-dbg "`$IncludedFolders count: <$($IncludedFolders.Length)>"

    write-dbg "`$ExcludedPatterns count: <$($ExcludedPatterns.Length)>"

 

    $Files = foreach ($I in $IncludedFolders) {

        get-childitem -recurse $I -file *.ps*1

    }

    write-dbg "`$Files count: <$($Files.Length)>"

 

    $SearchableFiles = foreach ($F in $Files) {

        $Filename = $F.fullname

        $Excluded = $False

 

        foreach ($P in $ExcludedPatterns) {

            if ($Filename -like $P ) {

                $Excluded = $True

            }

        }

 

        if ($Excluded -eq $False) {

            $F

        }

    }

    write-dbg "`$SearchableFiles count: <$($SearchableFiles.Length)>"

 

    select-string $SearchString $SearchableFiles | select path, line

 

}

set-alias sfs select-MuStringsFromCode

set-alias gfs select-MuStringsFromCode

 

 

 

 