function New-MuSpotifyPlaylistFromFile {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)][string]$FileName,
        [Parameter(Mandatory = $True)][string]$PlaylistName,
        [string]$ApplicationName = 'spotishell',
        [string]$PlaylistFolder = 'Created by spotishell',
        [string]$PlaylistDescription = 'Created from file $FileName on $(get-date)'
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    # create the playlist
    <#
    $NewPlaylistParams = @{
        PlaylistName        = $PlaylistName
        ApplicationName     = $ApplicationName
        PlaylistFolder      = $PlaylistFolder
        PlaylistDescription = $PlaylistDescription
    }
    $playlist = New-MuSpotifyPlaylist @NewPlaylistParams
    #>

    # reading the file
    $fileContent = Get-Content $FileName

    # for each line in the file, search for the track, output the list of tracks with an sequence number, and the
    # user can select which track best matches the line in the file (or none)
    $tracks = foreach ($line in $fileContent) {
        write-host $line
        $SplatParameters = @{
            SearchString    = $line
            ShowFirstHits   = 5
            ApplicationName = $ApplicationName
        }
        $track = Search-MuSpotifyItems @SplatParameters

        $SelectedTrack = $track | select -Property @{Label = 'Line'
            expression                                     = { 
                $line 
            } 
        },
        track,
        artist,
        album,
        released, 
        trackid | Out-GridView -OutputMode Single
        
        $TrackId = $SelectedTrack.trackid
        $Track = $SelectedTrack.track
        $Artist = $SelectedTrack.artist
        write-host -ForegroundColor Green "$Track $Artist $TrackId"

        # ask the user to select the track

        # add the track to the playlist
        # $track[$trackNumber] # | Add-MuSpotifyTrackToPlaylist -PlaylistName $PlaylistName -ApplicationName $ApplicationName -PlaylistFolder $PlaylistFolder -PlaylistDescription $PlaylistDescription
    }
    write-endfunction
   
   
}

function Add-MuSpotifyTrackToPlaylist {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
   
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
   
    write-endfunction
   
   
}

