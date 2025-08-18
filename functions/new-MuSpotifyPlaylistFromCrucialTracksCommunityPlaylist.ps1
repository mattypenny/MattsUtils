function New-MuSpotifyPlaylistFromCrucialTracksCommunityPlaylist {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        $CrucialTracksCommunityPlaylistURL
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    $WebPage = Invoke-WebRequest -Uri $CrucialTracksCommunityPlaylistURL -UseBasicParsing
    [string]$WebPageContent = $WebPage.Content
    write-dbg "`$WebPageContent count: <$($WebPageContent.Length)>"

    $WebPageContent = $WebPageContent -split "`r?`n"
   
    $Songs = $WebPageContent | select-string 'text-xl' -Context 0, 1  
    write-dbg "`$Songs count: <$($Songs.Length)>"

    foreach ($song in $Songs) {
        [string]$TitleLine = $song.Line 
        #        write-dbg "`$TitleLine: <$TitleLine>"
        if ($TitleLine -match '>(.*?)<') {
            $text = $matches[1]
        } 
        write-dbg "`$text: <$text>" 

        [string]$ArtistLine = $($song | select -ExpandProperty context | select -ExpandProperty postcontext)
        
        write-dbg "`$ArtistLine: <$ArtistLine>"
    }
    write-endfunction
   
   
}