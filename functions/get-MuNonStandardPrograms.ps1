function get-MuNonStandardPrograms {
<#
.SYNOPSIS
  Gets a list of programs deemed as non-standard or 'distinctive'
.DESCRIPTION
  Looks at registry and c:\program files
.PARAMETER ComputerNameList
  List of Computers, or just one
.NOTES
  StandardPrograms.csv is a list of names of software e.g.
name
----
Microsoft Help Viewer 1.1
VMware Tools
Microsoft Policy Platform
Common Files
Internet Explorer
#>
  [CmdletBinding()]

  Param ($ComputerNameList = ".")

  write-debug "In show-nonstandardprograms"

  $ArrayOfStandardprograms = import-csv $Env:PsParametersFolder\Standardprograms.csv | select name

  $Software = foreach ($ComputerName in $ComputerNameList)
  {

    get-InstalledSoftware -ComputerName $ComputerName

    get-SoftwareListFromProgramFiles -ComputerName $ComputerName

  }

  $Software | where { $ArrayOfStandardPrograms.name -notcontains $_.name }
}

