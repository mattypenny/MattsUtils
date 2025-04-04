function Get-MuChildItemSizeGroupedByTimeInterval {
    <#
.SYNOPSIS
    Used to show periodicity(?) of creation of a file such as a log file
#>
    [CmdletBinding()]
    param (
        $Path,
        $TimeIntervalDateFormat = 'yyMM'
    )

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')


    # Get the list of files in the specified folder
    $files = Get-ChildItem -Path $Path

    $FilesWithTimeInterval = $files |
        Select-Object @{L = 'lwm'
                        e = {
                            $_.lastwritetime.tostring( 'yyMM')
                        }
        }, length |
        Sort-Object -Property lwm

    $TotalLength = 0
    $CurrentMonth = ''
    $ChildItemSizeGroupedByTimeInterval = Foreach ($F in $FilesWithTimeInterval) {

        $RecordMonth = $F.lwm
        $Length = $f.length

        if ($CurrentMonth -ne $RecordMonth) {
            Write-Dbg "$CurrentMonth $TotalLength"
            [PSCustomObject]@{
                TimeSlice = $CurrentMonth
                TotalLength = $TotalLength
            }

            $CurrentMonth = $RecordMonth
            $TotalLength = 0
        }
        $TotalLength = $TotalLength + $Length
    }
    $ChildItemSizeGroupedByTimeInterval += [PSCustomObject]@{
        TimeSlice = $CurrentMonth
        TotalLength = $TotalLength
    }

    return $ChildItemSizeGroupedByTimeInterval


}
