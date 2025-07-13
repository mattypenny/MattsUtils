function Move-MuPodcastToStagingAndPrefixWithDate {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $False)][string]$SourceFolder = 'D:\Podcasts',
        [Parameter(Mandatory = $False)][string]$DestinationFolder = 'D:\PodcastsStaging'

    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    $Files = Get-ChildItem -Path $SourceFolder -File -Recurse

    foreach ($F in $Files) {
        $LastWriteTime = $F.LastWriteTime
        $FullName = $F.FullName
        $FileName = $F.Name

        $LastWriteTimeAsAString = $LastWriteTime.ToString('yyMMdd')
        $NewFileName = $LastWriteTimeAsAString + "_" + $FileName
        $NewFileName = $DestinationFolder + "\" + $NewFileName

        $RenameCommand = "Move-Item -Path `"$FullName`" -DEstination `"$NewFileName`""

        $RenameCommand

    }

   
    write-endfunction
   
   
}