function Get-MuADOrganizationalUnit {
  <#
.SYNOPSIS
  Get canonical names of OUs in alphabetical order, so you can see structure
#>
  [CmdletBinding()]
  param (

    [Alias("NameString")]$OUNameString = "*",
    [switch]$ShowUsers = $False,
    [switch]$ShowDistinguishedName = $False,
    [Parameter(Mandatory = $False)][string] $DomainController
  )

  $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')


  if ($DomainController) {
    $OUs = Get-ADOrganizationalUnit -Filter * -Properties CanonicalName -Server $DomainController
  }
  else {
    $OUs = Get-ADOrganizationalUnit -Filter * -Properties CanonicalName

  }


  $FilteredOUs = $OUs |
    Select-Object CanonicalName,
    DistinguishedName |
    Where-Object canonicalname -Like $OUNameString |
    Sort-Object -Property CanonicalName



  if ($ShowUsers) {

    $ReturnedUsers = @()
    foreach ($OU in $FilteredOUs) {

      $SearchBase = $OU.DistinguishedName
      $Users = Get-ADUser -Filter * -SearchBase $SearchBase -Properties * |
        Select-Object Name,
        @{ Label     = 'Boss'
          Expression = {
            $_.Manager.split(',')[0].split('=')[1]
          }
        },
        Department,
        Description,
        CanonicalName

      foreach ($U in $Users) {
        $ReturnedUsers += [PSCustomObject]@{
          UserName          = $U.Name
          UserCanonicalName = $U.CanonicalName
          Department        = $u.Department
          Description       = $U.Description
          Manager           = $U.Boss
          OuCanonicalName   = $OU.CanonicalName
        }
      }
    }

    $ReturnedUsers |
      Sort-Object -Property OUCanonicalName, USerName


  }
  else {

    if (!$ShowDistinguishedName) {

      $FilteredOUs = $FilteredOUs | Select-Object CanonicalName

    }

    $FilteredOUs

  }



}
Set-Alias get-MuOU Get-MuADOrganizationalUnit