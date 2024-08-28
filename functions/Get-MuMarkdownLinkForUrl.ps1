function Get-MuMarkdownLinkForUrl {
    <#
    .SYNOPSIS
        Get the webpage, extract the title, and build a markdown link for the specified URL
    #>
        [CmdletBinding()]
        [OutputType([String])]
        param (
            [Parameter(Mandatory=$True)][string]$Url
        )

        $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')


        $Webpage = invoke-webrequest $Url
        $Webpage.Content -match "<title>(?<title>.*)</title>" | out-null
        $Title = $matches['Title']

        "[$Title]($Url)"

    }
    set-alias gmd Get-MuMarkdownLinkForUrl
    set-alias Get-MarkdownLinkForUrl Get-MuMarkdownLinkForUrl