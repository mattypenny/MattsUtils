function get-MuGeneratedSplatLines {
    <#
    .SYNOPSIS
        Generate splat command for a specified function
    #>
    [CmdletBinding()]
    param (
        [string]$Function = "get-service"
    )

    [string]$SplatString = @"
`$SplatParams = @{
"@

    $Parameters = get-command $Function | Select-Object -ExpandProperty Parameters

    $CommonParameters = 'Verbose',
    'Debug',
    'ErrorAction',
    'WarningAction',
    'InformationAction',
    'ErrorVariable',
    'WarningVariable',
    'InformationVariable',
    'OutVariable',
    'OutBuffer',
    'PipelineVariable',
    'WhatIf',
    'Confirm'


    ForEach ($P in $Parameters.Keys) {
        [string]$Key = $P

        if ($CommonParameters -notcontains $Key) {

            $SplatString = @"
$SplatString
    $Key = `$$Key
"@

        }

    }

    $SplatString = @"
$SplatString
}

$Function @SplatParams
"@

    $SplatString

}


