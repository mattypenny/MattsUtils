function Search-MuSpotifyItems {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)][string] $SearchString,
        $applicationName = 'spotishell'

    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction

    # foreach ($t in $(search-Item 'hilly fields nick' -type Track -ApplicationName spotishell)) { foreach ($i in $($t | select -expand tracks | select -expand items)) {foreach ($a in $($i | select -expand artists))  { [PSCustomObject]@{artist=$a.name; track = $i.name; type = $i.type}}}}

    write-host 'welp'
    $tracks = search-Item $SearchString -type Track -ApplicationName spotishell
    write-dbg "`$tracks count: <$($tracks.Length)>"

    $songs = foreach ($t in $tracks) {

        $trackItems = $t | select -expand tracks | select -expand items
        write-dbg "`$trackitems count: <$($trackitems.Length)>"

        foreach ($i in $trackItems) {
            $artists = $i | select -expand artists
            write-dbg "`$artists count: <$($artists.Length)>"

            foreach ($a in $artists) {
                [PSCustomObject]@{
                    artist = $a.name
                    track  = $i.name
                    type   = $i.type
                }
            }

        }

    }
   
    write-endfunction
   
    return $songs
   
}