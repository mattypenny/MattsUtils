function get-MuGeneratedParameterDebugLines {
    <#
    .SYNOPSIS
        Generate write-debug lines for a call to a function
    #>
    [CmdletBinding()]
    param (
        [string]$Function = "get-service"
    )

    [string]$DebugString = @"
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

    $EscapeCharacter = '`'
    ForEach ($P in $Parameters.Keys) {
        [string]$Key = $P

        if ($CommonParameters -notcontains $Key) {

            $DebugString = @"
$DebugString
write-dbg "$EscapeCharacter`$$Key : <`$$Key>"
"@

        }

    }

    $DebugString = @"
$DebugString
}

$Function @SplatParams
"@

    $DebugString

}



