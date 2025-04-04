function get-MuContentFromLastFile {
    <#
    .SYNOPSIS
        Show content of last file for filespec (alias gcflf)
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
    write-debug "`$LatestFile: <$LatestFile>"

    get-content $LatestFile.fullname


}

set-alias gcflf get-MuContentFromLastFile

