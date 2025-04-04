function Get-MuInstalledSoftware {
<#
.SYNOPSIS
  Gets a list of programs from the registry Uninstall key
.DESCRIPTION
  This function was copied from Jeff Wouters: http://jeffwouters.nl/index.php/2014/01/a-powershell-function-to-get-the-installed-software/

  Only changes were
  - taking out the foreach Computer
  - reversing order of properties returned
  - adding cmdletbinding

.PARAMETER ComputerName
  Computer
#>
  [CmdletBinding()]

    param (
        [parameter(mandatory=$true)]$ComputerName
    )

    $OSArchitecture = (Get-ciminstance -ComputerName $ComputerName win32_operatingSystem -ErrorAction Stop).OSArchitecture
    if ($OSArchitecture -like "*64*") {
        $RegistryPath = 'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
    } else {
        $RegistryPath = 'Software\Microsoft\Windows\CurrentVersion\Uninstall'
    }
    $Registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $ComputerName)
    $RegistryKey = $Registry.OpenSubKey("$RegistryPath")
    $RegistryKey.GetSubKeyNames() | foreach {
       $Registry.OpenSubKey("$RegistryPath\$_") | Where-Object {($_.GetValue("DisplayName") -notmatch '(KB[0-9]{6,7})') -and ($_.GetValue("DisplayName") -ne $null)} | foreach {
            $Object = New-Object -TypeName PSObject
            $Object | Add-Member -MemberType noteproperty -name 'ComputerName' -value $ComputerName
            $Object | Add-Member -MemberType noteproperty -Name 'Source' -Value "Registry"
            $Object | Add-Member -MemberType noteproperty -Name 'Name' -Value $($_.GetValue("DisplayName"))
            $Object
        }
    }

}



