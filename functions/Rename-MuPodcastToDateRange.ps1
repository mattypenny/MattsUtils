function Rename-MuPodcastToDateRange {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)][string]$OriginalFileNameString,
        [Parameter(Mandatory = $True)][string]$StartDateInYYMMDDFormat,
        [Parameter(Mandatory = $False)][int]$IntervalInDays = 5
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    $Files = Get-ChildItem -Path $OriginalFileNameString -File
    if ($Files.Count -eq 0) {
        write-dbg "No files found matching: <$OriginalFileNameString>"
        throw "No files found matching: <$OriginalFileNameString>"
    }

    # Convert specified date strings to DateTime objects
    $RenameDate = [datetime]::ParseExact($StartDateInYYMMDDFormat, 'yyMMdd', $null)
    write-dbg "`$RenameDate: <$RenameDate>"
    
    foreach ($File in $Files) {
        $Fullname = $File.FullName
        write-dbg "Processing file: <$FullName>"
         
        $FileName = $File.Name
        $FolderName = $File.DirectoryName
        write-dbg "File name: <$FileName>, Folder: <$FolderName>"

        $RenameDateAsAString = $RenameDate.ToString('yyMMdd')
        $NewFileName = $RenameDateAsAString + "_" + $FileName

        $NewFullName = Join-Path -Path $FolderName -ChildPath $NewFileName

        $RenameCommand = "Rename-Item -Path `"$Fullname`" -NewName `"$NewFullName`""

        $RenameCommand  

        $RenameDate = $RenameDate.AddDays($IntervalInDays)

        write-dbg "`$RenameDate: <$RenameDate>"
   
    }
   
    write-endfunction
   
   
}