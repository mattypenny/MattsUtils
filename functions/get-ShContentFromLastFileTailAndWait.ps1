function get-ShContentFromLastFileTailAndWait {
    <#
    .SYNOPSIS
       Show content of last file for filespec (alias tflf)
    .DESCRIPTION
        Longer description


    .PARAMETER FileSpecification
        Filespec e.g. c:\temp\*.log
    .EXAMPLE
        get-Shcontentfromlastfile c:\temp\*.log

    #>
    [CmdletBinding()]
    Param( [string]$FileSpecification = "C:\temp\*.log" )

    write-startfunction

    $LatestFile = Get-ChildItem $FileSpecification | sort-object -property lastwritetime | select -last 1 | select fullname


    Get-Content  -Tail 200 -Wait  -Path $LatestFile.fullname

    write-endfunction

}

set-alias tcflf get-ShContentFromLastFileTailAndWait
set-alias tflf get-ShContentFromLastFileTailAndWait
