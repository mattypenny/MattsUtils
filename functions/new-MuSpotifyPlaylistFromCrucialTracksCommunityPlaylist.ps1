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

    $WebPageContent | convertfrom-html  | ? innerhtml -like '*<div class="font-medium text-xl">*' | select @{L = 'song'; E = { $_.innertext.trim() } }
    [string]$InnerHtml = $($WebPageContent  | convertfrom-html).innerhtml
    [string[]]$HtmlLines = $InnerHtml -split "`n"
    $Songs = $HtmlLines | ? { $_ -like '*<div class="font-medium text-xl">*' }
    write-dbg "`$Songs count: <$($Songs.Length)>"
    $Songs

    <#
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
    #>
   
   
}