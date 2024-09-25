function get-MuContentFromLastFileTailAndWait {
    <#
    .SYNOPSIS
       Show content of last file for filespec (alias tflf)
    .DESCRIPTION
        Longer description


    .PARAMETER FileSpecification
        Filespec e.g. c:\temp\*.log
    .EXAMPLE
        get-Mucontentfromlastfile c:\temp\*.log

    #>
    [CmdletBinding()]
    Param( [string]$FileSpecification = "C:\temp\*.log" )


    $LatestFile = Get-ChildItem $FileSpecification | sort-object -property lastwritetime | select -last 1 | select fullname


    Get-Content  -Tail 200 -Wait  -Path $LatestFile.fullname


}

set-alias tcflf get-MuContentFromLastFileTailAndWait
set-alias tflf get-MuContentFromLastFileTailAndWait
