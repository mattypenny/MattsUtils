function Get-MuUsersInOu {
  [CmdletBinding()]
  param (
    $SearchBase,
    [switch]$Pending = $False,
    [switch]$Leavers = $False
  )

  if ($Pending) {

    [string]$SearchBase = Get-MuGeneralParameter -Program 'Get-MuUsersInOu' -Parameter 'Pending'

  }

  if ($Leavers) {

    [string]$SearchBase = Get-MuGeneralParameter -Program 'Get-MuUsersInOu' -Parameter 'Leavers'

  }

  $Users = get-ADUser -filter * -searchbase $SearchBase -properties * |
        select SamAccountName,
               Department,
               Description,
               CanonicalName,
               @{ Label = 'Boss'
                  Expression = {
                    $_.Manager.split(',')[0].split('=')[1]
                  }
               }




  $Users |
    sort-object -Property CanonicalName

}

