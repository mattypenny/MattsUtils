function Generate-MuBlogPostFromSpotifyPlaylist {
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
   
   write-startfunction
   
   
   write-endfunction
   
   
}

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
         Select-Object -Last 1
            
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
   
   $Playlist = Get-CurrentUserPlaylists | Where-Object name -eq $PlaylistName
   
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
      $Songs
   )
   
   $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
   write-startfunction
   
   
   write-endfunction
   
   
}

function Get-MuPostBody {
<#
.SYNOPSIS
   xx
#>
   [CmdletBinding()]
   param (
      [Parameter(Mandatory=$True)]$Songs,
      [Parameter(Mandatory=$True)][string]$BodyPath
   )
   
   $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
   write-startfunction
   
   write-dbg "`$Songs count: <$($Songs.Length)>"
   $PostBody=""
   
   foreach ($S in $Songs) {
      [string]$Artist    = $S.Artist
      [string]$TrackName = $S.TrackNAme
      [string]$MusicURL  = $S.MusicURL
      [string]$Album     = $S.Album
      [string]$ImageURL  = $S.Image
   
      <#
      <p>
<img src="/tmp/spotify/ab67616d0000b273efd23057f80e32da5b1c0345.jpeg" alt="Smiley face" style="float:left;width:42px;height:42px;margin-right:10px">     <a href="https://open.spotify.com/track/22QMzoI3O7yNnttjKq9SfF">Draggin' the Line - Tommy James & The Shondells]</a> - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx sdsuhdushdushdushdu
</p>
      #> 
      $PostBody = @"
$PostBody
<p>
   <img 
      src="/tmp/spotify/ab67616d0000b273efd23057f80e32da5b1c0345.jpeg" 
      alt="Cover of the Spotify 'album' - $Album"
      style="float:left;width:42px;height:42px;margin-right:10px">
   <a href=
      "$MusicURL">
      $TrackName - $Artist
   </a> 
   - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx sdsuhdushdushdushdu
</p>
"@

   }
   
   Output-MuPostBodyToFile -BodyPath $BodyPath -PostBody $PostBody 
   
   write-endfunction

   $PostBody
   
   
}

function Output-MuPostBodyToFile {
<#
.SYNOPSIS
   xx
#>
   [CmdletBinding()]
   param (
      [Parameter(Mandatory=$True)][string]$PostBody,
      [Parameter(Mandatory=$True)][string]$BodyPath  
   )
   
   $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
   write-startfunction
   
   Set-Content -path $BodyPath -Value $PostBody
   
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
function write-startfunction {
   <#
   .SYNOPSIS
      xx
   #>
      [CmdletBinding()]
      param (
      
      )
      
      $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
      
      
      
   }
   
   function write-endfunction {
   <#
   .SYNOPSIS
      xx
   #>
      [CmdletBinding()]
      param (
      
      )
      
      $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
      
      
      
   }
function write-startfunction {
   <#
   .SYNOPSIS
      xx
   #>
      [CmdletBinding()]
      param (
      
      )
      
      $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
      
      
      
   }
   
   function write-endfunction {
   <#
   .SYNOPSIS
      xx
   #>
      [CmdletBinding()]
      param (
      
      )
      
      $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
      
      
      
   }