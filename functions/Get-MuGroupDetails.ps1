function Get-MuGroupDetails {
    <#
.SYNOPSIS
    xx
#>
    [CmdletBinding()]
    param (

    )

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

    $AllTheGroups = Get-ADGroup -filter *  -Properties *
    $GroupDetails = foreach ($Group in $AllTheGroups | Sort-Object -Property name) {

        $CountOfMembers = $($Group | Select-Object -expand member | Measure-Object).count
        $Users = ''
        if ($CountOfMembers -lt 4) {
            $Members = $Group | Select-Object -expand member
            foreach ($M in $Members) {
                try {
                    $U = Get-ADUser -Filter { DistinguishedName -eq $M }
                    [string]$SamAccountName = $U.SamAccountName

                }
                catch {
                    Write-Host "Can't find $M"
                    $SamAccountName = 'x'
                }
                Write-Host $SamAccountName

                $Users = $Users + $SamAccountName + ' '
            }
        }
        $Name = $Group.Name
        Write-Host "$Name - $CountOfMembers - $Users"
        [PSCustomObject]@{GroupName = $Name
            CountOfMembers          = $CountOfMembers
            UserIFLessThan4         = $Users
            Description             = $Group.Description
            WhenCreated             = $Group.WhenCreated
            Type                    = $Group.GroupCategory
        }

    }

}
