function get-ShContentFromLastFile {
    <#
    .SYNOPSIS
        Show content of last file for filespec (alias gcflf)
    .DESCRIPTION
        Longer description


    .PARAMETER
        Filespec e.g. c:\temp\*.log
    .EXAMPLE
        get-Shcontentfromlastfile c:\temp\*.log

    #>
    [CmdletBinding()]
    Param( [string]$FileSpecification = "C:\temp\*.log" )

    write-startfunction

    $LatestFile = Get-ChildItem $FileSpecification | sort-object -property lastwritetime | select -last 1 | select fullname
    write-debug "`$LatestFile: <$LatestFile>"

    get-content $LatestFile.fullname

    write-endfunction

}

set-alias gcflf get-ShContentFromLastFile

