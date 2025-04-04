function Get-MuComputer {
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
        write-dbg "`$DnsHostname: <$DnsHostname>"

        if (!($DnsHostname)) {
            $DnsHostName = $C.Name
        }
        try {
            $DnsRecord = Resolve-DnsName $DnsHostName -ErrorAction Stop
            $IPAddress = $DnsRecord.IPAddress
        }
        catch {
            $IPAddress = 'not found'

        }

        [PSCustomObject]@{
            ComputerName = $C.DNSHostName
            IPAddress    = $IPAddress
        }
    }
    write-endfunction


}
Set-Alias Get-MuComputerNames -Value Get-MuComputers
Set-Alias Get-MuComputers -Value Get-MuComputerNames
Set-Alias MuList -Value Get-MuComputerNames
Set-Alias CList -Value Get-MuComputerNames