function Get-MuUsersWithinGroups {
  <#
.SYNOPSIS
  xx
#>
  [CmdletBinding()]
  param (
    $GroupString
  )

  $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')


  $ADGroups = Get-ADGroup -Filter { name -like $GroupString }
  $ADGroupsCount = $( $ADGroups | Measure-Object).count
  write-dbg "`$ADGroupsCount: <$ADGroupsCount>"

  $GroupMembers = foreach ($G in $ADGroups) {

    $Name = $G.Name
    write-dbg "`$Name: <$Name>"

    try {
      $AdGroupMembers = Get-ADGroupMember -Identity $Name
    }
    catch {

    }

    foreach ($M in $AdGroupMembers) {
      [PSCustomObject]@{
        GroupName      = $G.Name
        MemberName     = $M.name
        SamAccountName = $M.SamAccountName
      }
    }
  }
  $GroupMembers

}

