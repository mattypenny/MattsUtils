function grant-MuLocalAdmin {
  <#
.SYNOPSIS
Grant local admin on specified server to specified group or user

.DESCRIPTION
This function grants local admin and remote management rights to specified group or user


.PARAMETER ComputerName
Specify the remote server.

.PARAMETER UserName
Specify the User or Group

.INPUTS
None. You cannot pipe objects to this function

.EXAMPLE




#>
  [CmdletBinding()]
  Param( [String]$ComputerName,
    [Parameter(Mandatory = $True)] [string]$Domain,
    [String]$UserName = "Y" )

  Write-Debug "Server $ComputerName"
  Write-Debug "User $Username"

  Write-Debug "Before:"
  foreach ($U in $(get-WSLocalGroupMemberShip -ComputerName $ComputerName -Group "Administrators")) {
    [string]$group = $U.Group
    [string]$user = $U.Username
    Write-Debug "<$Group> <$User>"
  }
  foreach ($U in $(get-WSLocalGroupMemberShip -ComputerName $ComputerName -Group "Remote desktop users")) {
    [string]$group = $U.Group
    [string]$user = $U.Username
    Write-Debug "<$Group> <$User>"
  }

  Write-Debug "Adding to admin"
  $MemberObject = [ADSI]"WinNT://$ComputerName/administrators,group"
  $MemberObject.add("WinNT://$ComputerName/$Domain/$UserName")

  Write-Debug "Adding to Remote desktop Users"
  $MemberObject = [ADSI]"WinNT://$ComputerName/Remote desktop users,group"
  $MemberObject.add("WinNT://$ComputerName/$Domain/$USERName")

  Write-Debug "After:"
  foreach ($U in $(get-WSLocalGroupMemberShip -ComputerName $ComputerName -Group "Administrators")) {
    [string]$group = $U.Group
    [string]$user = $U.Username
    Write-Debug "<$Group> <$User>"
  }
  foreach ($U in $(get-WSLocalGroupMemberShip -ComputerName $ComputerName -Group "Remote desktop users")) {
    [string]$group = $U.Group
    [string]$user = $U.Username
    Write-Debug "<$Group> <$User>"
  }
}

