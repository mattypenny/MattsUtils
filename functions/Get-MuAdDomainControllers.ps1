function Get-MuAdDomainControllers {
  [CmdletBinding()]
  param (

  )

  $Result = @()

  $Domains = Get-ADTrust -filter *
  $DomainsCount = $( $Domains | measure-object).count
  write-dbg "`$DomainsCount: <$DomainsCount>"

  foreach ($D in $Domains) {

      [string]$Name = $D.Name
      write-dbg "`$Name: <$Name>"

      $DomainController = Get-ADDomainController -DomainName $Name -Discover
      $Domain = get-ADDomain -identity $Name

      [string]$DCName = $DomainController.Name
      write-dbg "`$DCName: <$DCName>"

      [string]$DcFqdn = "${DcName}.${Name}"
      write-dbg "`$DcFqdn: <$DcFqdn>"

      $Result += [PSCustomObject]@{
          Domain = $Name
          DomainController = $DcFqdn
          Server = $Domain.InfrastructureMaster
          DomainSid = $Domain.DomainSid
          Local = $False
      }
  }

  $CurrentDomainDomainController = Get-ADDomainController

  [string]$Name = $CurrentDomainDomainController.Domain
  $Domain = get-ADDomain -identity $Name

  [string]$CurrentDomainDomainControllerName = $CurrentDomainDomainController.Hostname
  write-dbg "`$CurrentDomainDomainControllerName: <$CurrentDomainDomainControllerName>"

  $Result += [PSCustomObject]@{
      Domain = $CurrentDomainDomainController.Domain
      DomainController = $CurrentDomainDomainController.Hostname
      Server = $Domain.InfrastructureMaster
      DomainSid = $Domain.DomainSid
      Local = $True
  }

  $Result
}
