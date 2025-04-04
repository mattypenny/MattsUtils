function Get-MuAclPlus {
  <#
  .SYNOPSIS
    Gets permissions for folders, and optionally files, and optionally expands the groups
  .EXAMPLE
    Get-AclPlus -FolderName  \\Server1\New-MuUserJobRoleTemplatesStaging -FoldersOnly -ExpandGroups -Recurse
  .NOTES
    TODO: The exclusions bit isn't working yet
  #>
  [CmdletBinding()]
  param (
    [string[]]$FolderName,
    [string[]]$Exclusions = ('NT AUTHORITY\SYSTEM'),
    [switch]$ExpandGroups,
    [switch]$FoldersOnly = $True,
    [switch]$Recurse = $False
  )

  $Items = @()
  $Items += get-item $FolderName
  $Items += Get-ChildItem $FolderName -Directory:$FoldersOnly -Recurse:$Recurse

  $Access = foreach ($F in $Items) {

    $FullName = $F.Fullname

    write-dbg "`$Fullname: <$Fullname>"

    $Access = Get-Acl $FullName |
      Select-Object -ExpandProperty Access

    foreach ($a in $Access) {

      [string]$IdentityReference = $A.IdentityReference
      write-dbg "  `$IdentityReference: <$IdentityReference>"

      if ($IdentityReference -notin ($Exclusions)) {

        try {
          $UserName = $IdentityReference.Split('\')[1]
          write-dbg "`$Username: <$Username>"
          $ADUser = Get-ADUser -Identity $Username -ErrorAction Stop
        }
        catch {
          $ADUser = ''
        }

        if ($ADUser -Or ($ExpandGroups -eq $False)) {
          write-dbg "    Not expanding"
          [PSCustomObject]@{
            FullName          = $FullName
            FileSystemRights  = $A.FileSystemRights
            AccessControlType = $A.AccessControlType
            IdentityReference = $A.IdentityReference
          }
        }
        else {
          write-dbg "    Not expanding"
          $GroupName = $IdentityReference.Split('\')[1]
          $Members = Get-ADGroupMember $GroupName -Recursive
          foreach ($M in $Members) {
            [PSCustomObject]@{
              Fullname = $Fullname
              FileSystemRights = $A.FileSystemRights
              AccessControlType = $A.AccessControlType
              IdentityReference = $M.SamAccountName
            }
          }

        }
      }


    }


  }

  return $Access

}