function Rename-MuMp3sWithTitle {
   <#
.SYNOPSIS
   xx
#>
   [CmdletBinding()]
   param (
      [Parameter(Mandatory = $True)][string] $Path
   )
   
   $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
   write-startfunction

   Add-Type -Path 'C:\Program Files\PackageManagement\NuGet\Packages\TagLibSharp.2.3.0\lib\net462\TagLibSharp.dll'
   foreach ($File in Get-ChildItem -Path $Path -Filter *.mp3 -Recurse) {
      $FullName = $File.FullName
      $TagLibFile = [TagLib.File]::Create($FullName)
      $Title = $TagLibFile.Tag.Title
      $Title = $title -replace ':', '-'  # replace colon with dash to avoid issues in filenames
      if (![string]::IsNullOrEmpty($Title)) {
         $Directory = $File.DirectoryName
         $Extension = $File.Extension
         $NewFileName = "$Directory\$Title$Extension"
         if ($FullName -ne $NewFileName) {
            write-host "Rename-Item -Path $FullName -NewName $NewFileName -verbose"
            Rename-Item -Path $FullName -NewName $NewFileName -verbose
         }
      }
   }
   
   
   write-endfunction
   
   
}
