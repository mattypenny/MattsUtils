function Get-MuSpotifyPlaylistSongs {
   <#
.SYNOPSIS
   xx
#>
   [CmdletBinding()]
   param (
      [Parameter(Mandatory = $False)][string]$PlaylistName = 'Discovered in 2024',
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
         $TrackName = $T.Name

         # There does only seem to be on URL per track
         $External_URL = $T | 
         Select-Object -ExpandProperty External_Urls |
         Select-Object -First 1

         $Album = $T |
         Select-Object -ExpandProperty Album |
         Select-Object -first 1  # only expecting 1, but...

         $FirstImage = $Album |
         Select-Object -ExpandProperty Images |
         Sort-Object -Property Width |
         Select -Last 1
            
         $Artists = $T |
         Select-Object -ExpandProperty Artists

         $ArtistString = ""
         foreach ($A in $Artists) {
            $Name = $A.name
            $ArtistString = "$Artiststring,$Name" 
         }
         $ArtistString = $ArtistString.TrimStart(',')
         [PSCustomObject]@{
            AddedAt   = $I.Added_At
            Artist    = $ArtistString
            TrackName = $T.NAme
            MusicURL  = $External_URL.Spotify
            Album     = $Album.Name
            ImageURL  = $FirstImage.url

         }
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
      [Parameter(Mandatory = $True)][string]$PlaylistName
   )
   
   $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
   write-startfunction
   
   $Playlist = Get-CurrentUserPlaylists | ? name -eq $PlaylistName
   
   $Id = $Playlist.Id

   write-endfunction

   return $Id
   
   
}

function New-MuBlogPostFromSpotifySongs {
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

function Copy-MuSpotifyImageToBlog {
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

function Copy-MuSpotifyImageToComputer {
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

function Copy-MuComputerImageToBlog {
<#
.SYNOPSIS
   Returns location of image on blog website
#>
   [CmdletBinding()]
   param (
   
   )
   
   $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
   write-startfunction
   
   
   write-endfunction
   
   
}

