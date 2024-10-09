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
Set-Alias Get-MuComputer -Value Get-MuComputerNames
Set-Alias Get-MuComputers -Value Get-MuComputerNames
Set-Alias MuList -Value Get-MuComputerNames
Set-Alias CList -Value Get-MuComputerNames