function Get-MuSpotifyPlaylistSongs {
<#
.SYNOPSIS
   xx
#>
   [CmdletBinding()]
   param (
    [Parameter(Mandatory=$False)][string]$PlaylistName = 'Discovered in 2024',
    $Since = $(get-date).adddays(-14)
   )
   
   $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
   $PlaylistId = Get-MuSpotifyPlaylistId -PlaylistName $PlaylistName
   
    $PlayListItems = Get-PlaylistItems $PlaylistId
        write-dbg "`$PlayListItems count: <$($PlayListItems.Length)>"

    $PlayListItems = $PlayListItems |
        Where-Object added_at -gt $Since
        Sort-Object -property added_at 
    
        write-dbg "`$PlayListItems count: <$($PlayListItems.Length)>"
   foreach ($I in $PlayListItems) {
      $Addedat = $I.added_at
      write-dbg "`$AddedAt: <$AddedAt>"
      $Tracks = $I | Select-Object -ExpandProperty Track
      foreach ($T in $Tracks) {
         $T
      }
   }
    
    
   
   # Get-PlaylistItems 4IDjIaydoGw4zODeBh7SUX #    select -expand tracks | select -expand items | select -expand track | select name
   
}

function Get-MuSpotifyPlaylistId {
<#
.SYNOPSIS
   xx
#>
   [CmdletBinding()]
   param (
        [Parameter(Mandatory=$True)][string]$PlaylistName
   )
   
   $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
   write-startfunction
   
   $Playlist = Get-CurrentUserPlaylists | ? name -eq $PlaylistName
   
   $Id = $Playlist.Id

   write-endfunction

   return $Id
   
   
}
