function Get-MuComputerNames {
    <#
.SYNOPSIS
    Gets names from AD
#>
    [CmdletBinding()]
    param (
        $ComputerName
    )

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

    write-startfunction

    $ADComputers = Get-ADComputer -Filter * -Properties * |
        Where-Object DNSHostName -Like "*$ComputerName*"

    foreach ($C in $ADComputers) {
        [string]$DnsHostName = $C.DNSHostName

        $DnsRecord = Resolve-DnsName $DnsHostName

        [PSCustomObject]@{
            ComputerName = $C.DNSHostName
            IPAddress    = $DnsRecord.IPAddress
        }
    }
    write-endfunction


}