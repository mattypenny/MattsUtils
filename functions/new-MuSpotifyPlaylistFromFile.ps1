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
        [string]$PlaylistDescription = "Created from file $FileName on $(get-date)"
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    # create the playlist
    
    $NewPlaylistParams = @{
        PlaylistName        = $PlaylistName
        ApplicationName     = $ApplicationName
        PlaylistFolder      = $PlaylistFolder
        PlaylistDescription = $PlaylistDescription
    }
    $playlist = New-MuSpotifyPlaylist @NewPlaylistParams
   

    # reading the file
    $fileContent = Get-Content $FileName

    # for each line in the file, search for the track, output the list of tracks with an sequence number, and the
    # user can select which track best matches the line in the file (or none)
    $tracks = foreach ($line in $fileContent) {

        if (!($line)) {
            continue
        }
        if ($line -match '^\s*#') {
            continue
        }
        if ($line -match '^\s*$') {
            continue
        }
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
        write-dbg "User selected: <$Track> by <$Artist> which has a Spotty id of <$TrackId>"

        Add-MuSpotifyTrackToPlaylist -PlaylistId $playlist.Id -TrackId $SelectedTrack.TrackId -ApplicationName $ApplicationName
    }
    write-endfunction
   
   
}

function New-MuSpotifyPlaylist {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        $ApplicationName     ,
        $PlaylistDescription ,
        $PlaylistFolder      ,
        $PlaylistName        
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    $Playlist = New-Playlist -UserId (Get-CurrentUserProfile -ApplicationName $ApplicationName).id -Name $PlaylistName -Description $PlaylistDescription -ApplicationName $ApplicationName
   
    write-dbg "`$Playlist count: <$($Playlist.Length)>"
    write-endfunction
   
    return $Playlist
   
}
function Add-MuSpotifyTrackToPlaylist {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]$PlaylistId,
        [Parameter(Mandatory = $True)]$TrackId,
        [Parameter(Mandatory = $True)][string]$ApplicationName 
   
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    if ($PlaylistId -notmatch '^[a-zA-Z0-9]{22}$') {
        write-dbg "Invalid PlaylistId: <$PlaylistId>"
        throw "Invalid PlaylistId: <$PlaylistId>"
    }
    else {
        write-dbg "PlaylistId OK: <$PlaylistId>"
    }
    if ($TrackId -notmatch '^[a-zA-Z0-9]{22}$') {
        write-dbg "Invalid TrackId: <$TrackId>"
        throw "Invalid TrackId: <$TrackId>"
    }
    else {
        write-dbg "TrackId OK: <$TrackId>"
    }

    try {
        write-dbg "Adding track <$TrackId> to playlist <$PlaylistId> with application name <$ApplicationName>"
        Add-PlaylistItem -Id $PlaylistId -ItemId $TrackId -ApplicationName $ApplicationName
        $TrackAdded = $True
    }
    catch {
        write-error "Error adding track to playlist: $_"
        $TrackAdded = $False
    }
    write-endfunction

    return $TrackAdded
   
   
}

