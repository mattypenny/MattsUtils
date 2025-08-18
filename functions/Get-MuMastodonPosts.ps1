function Get-MuMastodonPosts {
    <#
.SYNOPSIS
   Get mastodon posts from a specified user or hashtag.
#>
    [CmdletBinding()]
    param (
        $Hashtag
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    $Posts = Invoke-RestMethod -Uri "https://mastodon.social/api/v1/timelines/tag/$Hashtag" -Method Get

    # Define the Mastodon instance and hashtag you want to search for
    $instance = "mastodon.social"              # Replace with the instance you want to query
    $hashtag = "PowerShell"                     # Replace with your desired hashtag (without #)
    $limit = 40                                # Max items per request (up to 40)

    # Initial endpoint URL
    $url = "https://$instance/api/v1/timelines/tag/$hashtag?limit=$limit"

    # Array to store all posts
    $allPosts = @()

    while ($url) {
        # Make the request and store the response and headers
        $response = Invoke-RestMethod -Uri $url -Headers @{ "User-Agent" = "PowerShell Script" }

        # Append fetched statuses/posts to the array
        $allPosts += $response

        # Extract the Link header for pagination (it's in raw response headers, so we must get them separately)
        # Unfortunately, Invoke-RestMethod doesn't return headers directly, so use Invoke-WebRequest instead
        $webResponse = Invoke-WebRequest -Uri $url -Headers @{ "User-Agent" = "PowerShell Script" }

        # Check if Link header exists for pagination
        $linkHeader = $webResponse.Headers["Link"]

        # Parse Link header to find "next" URL if available
        $nextUrl = $null
        if ($linkHeader) {
            # Link header format: <https://...&max_id=xxxx>; rel="next", <...>; rel="prev"
            foreach ($link in $linkHeader.Split(',')) {
                if ($link -match 'rel="next"') {
                    if ($link -match '<(.+?)>') {
                        $nextUrl = $matches[1]
                    }
                }
            }
        }

        # Set url for next fetch or terminate loop if none
        $url = $nextUrl
    }

    # At this point, $allPosts contains all fetched toots with the hashtag
    Write-Output "Total posts fetched: $($allPosts.Count)"

    # Display some info, for example content of first 5 posts
    $allPosts | Select-Object -First 5 | ForEach-Object {
        Write-Output $_.content
        Write-Output "--------------------------------------"
    }


   
    write-endfunction
   
    $Posts
   
}