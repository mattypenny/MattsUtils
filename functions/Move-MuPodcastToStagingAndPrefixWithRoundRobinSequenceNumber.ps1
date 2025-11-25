function Move-MuPodcastToStagingAndPrefixWithRoundRobinSequenceNumber {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $False)][string]$SourceFolder = 'c:\Podcasts',
        [Parameter(Mandatory = $False)][string]$DestinationFolder = 'c:\PodcastsStaging',
        [Parameter(Mandatory = $False)][int]$SequenceStart = 20000000

    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
    $ErrorActionPreference = 'Stop'
   
    write-startfunction
   

    $Folders = $(Get-ChildItem -directory -Path $SourceFolder  -Recurse)
    $Files = $(Get-ChildItem -file -Path $SourceFolder  *.mp3 -Recurse)
    $NumberOfFiles = $Files.Count
    $Stop = $SequenceStart + $NumberOfFiles - 1

    $Prefix = $SequenceStart

    for ($i = $SequenceStart; $i -le $Stop; $i++) {
        
        foreach ($Folder in $Folders) {
            $FirstFileInFolder = get-childitem -Path $Folder *.mp3 |
            sort-object name |
            select-object -First 1

            if ($FirstFileInFolder) {
                $Prefix += 1
                $FileName = $FirstFileInFolder.Name
                $NewFilename = $Prefix.ToString("D8") + "_" + $FileName

                Move-Item -Path $FirstFileInFolder.FullName -Destination ($DestinationFolder + "\" + $NewFilename) -Verbose
            }

        }

    }

   
    write-endfunction
   
   
}