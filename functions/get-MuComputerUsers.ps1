<#
.SYNOPSIS
    Get local users of computer (PowerShell 7 compatible)
.DESCRIPTION
    Retrieves local users belonging to groups on the specified computer.
.EXAMPLE
    Get-MuComputerUsers -ComputerName "server1"
#>
function Get-MuComputerUsers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        [string] $ComputerName
    )



    $GroupUser = Get-CimInstance -ClassName Win32_GroupUser -ComputerName $ComputerName

    $GroupUser | Select-Object @{
        Label      = "Group"
        Expression = {
            $_.GroupComponent -replace 'Win32_Group \(Domain = "', '' `
                -replace '", Name = "', '\' `
                -replace '"\)', ''
        }
    },
    @{
        Label      = 'Part'
        Expression = {
            $_.PartComponent -replace 'Win32_', '' `
                -replace '\(Domain = "', '' -replace '", Name = "', '\' `
                -replace '"\)', '' `
                -replace 'Group', '' `
                -replace 'SystemAccount', '' `
                -replace 'UserAccount'
        }
    }
}

Set-Alias Get-MuLocalUsers Get-MuComputerUsers