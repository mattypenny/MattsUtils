function get-MuNonStandardServices {
<#
.SYNOPSIS
  Gets a list of services deemed as non-standard or 'distinctive'
.DESCRIPTION
  This function is autoloaded by .matt.ps1
.PARAMETER ComputerNameList
  List of Computers, or just one
#>
  [CmdletBinding()]

  Param ($ComputerNameList = ".")

  write-debug "In show-Munonstandardservices"

  $ArrayOfNonStandardServices = import-csv $Env:PsParametersFolder\StandardServices.csv | select name

  $Services = foreach ($ComputerName in $ComputerNameList)
  {
    get-ciminstance -classname Win32_service -computername $ComputerName |
        where { $ArrayOfNonStandardServices.name -notcontains $_.name } |
        where name -notlike "*CDPUserSvc*"  |
        where name -notlike "*WPNUserService*"  |
        where name -notlike "*CaptureService*"  |
        where name -notlike "*cbdhsvc*"  |
        where name -notlike "*ConsentUxUserSvc*"  |
        where name -notlike "*DevicePickerUserSvc*"  |
        where name -notlike "*DevicesFlowUserSvc*"  |
        where name -notlike "*PimIndexMaintenanceSvc*"  |
        where name -notlike "*PrintWorkflowUserSvc*"  |
        where name -notlike "*UnistoreSvc*"  |
        where name -notlike "*UserDataSvc*"
  }

  return $Services

}

function show-Munonstandardservices {
<#
.SYNOPSIS
  Gets and format a list of services deemed as non-standard or 'distinctive', with options for properties shown
.PARAMETER ComputerNameList
  List of Computers, or just one
.PARAMETER Option
  Default, Def, 0 - shows server, names, state, auto/manual
  Alternative, Alt, 1 - shows server, name, login, auto/manual
  Starttime, Process, Start, 2 - shows server, names, state, auto/manual, startup time
#>
  Param ([Parameter(Position=1)]$ComputerNameList = ".",
         [ValidateSet('default','def','0',
                      'alternative','alt','1',
                      'starttime', 'process', 'start','2',
                      'csv',
                      'WithStartCommand','3')]$option = 'default')

  if ($option -in 'default','def','0')
  {
    get-MuNonStandardServices $ComputerNameList |
      select PSComputerName, name, DisplayName,state, startmode |
      sort -uniq PSComputerName, state, name | ft -a
  }
  elseif ($option -in 'alternative','alt','1')
  {
    get-MuNonStandardServices $ComputerNameList |
      select PSComputerName, name, startname, startmode |
      sort -uniq PSComputerName, state, name
  }
  elseif ($option -in 'starttime', 'process', 'start', 2)
  {

    $ServicesToOutput = foreach ($ComputerName in $ComputerNameList)
    {
      $Services = get-MuNonStandardServices $ComputerName | sort -uniq PSComputerName, state, name

      foreach ($Service in $Services)
      {
        $ProcessId = $Service.ProcessId

        $Process = Get-CimInstance -Class Win32_Process -ComputerName $ComputerName -Filter "ProcessID='$ProcessId'"


        # todo: could add in memory usage etc
        $Service | Add-Member -MemberType NoteProperty -Name StartTime -Value $($Service.ConvertToDateTime($Process.CreationDate))

        $Service
      }
    }




    $ServicesToOutput |
      select PSComputerName, name, DisplayName,state, starttime, ProcessId |
      sort  PSComputerName, state, name
  }

  elseif ($option -in 'csv' )
  {

    $ServicesToOutput = @()

    foreach ($ComputerName in $ComputerNameList)
    {
      [string]$Fqdn = ([System.Net.Dns]::GetHostByName(("$Computername"))).Hostname
      write-dbg "`$Fqdn: <$Fqdn>"

      $Services = get-MuNonStandardServices $ComputerName
      $ServicesCount = $( $Services | measure-object).count

      write-dbg "`$ServicesCount: <$ServicesCount>"

      foreach ($Service in $Services)
      {

        $Name = $Service.Name
        write-dbg "`$Name: <$Name>"

        $ServicesToOutput += $Service | Add-Member -Name Fqdn -Value $Fqdn -MemberType NoteProperty

        $ServicesToOutput += [PSCustomObject]@{
          Fqdn = $Fqdn
          Name = $Name
          DisplayName = $Service.DisplayName
          State = $Service.State
        }

        $ServicesToOutputCount = $( $ServicesToOutput | measure-object).count
        write-dbg "`$ServicesToOutputCount: <$ServicesToOutputCount>"

      }

    }


    $ServicesToOutput |
      Where-Object state -eq 'Running' |
      Select-Object Fqdn,
                    @{Label = 'ShouldBeRunning'; Expression = {'Y'}},
                    name,
                    DisplayName |
      ConvertTo-Csv -NoTypeInformation



  }
  elseif ($option -in 'withstartcommand', 3)
  {

    $ServicesToOutput = foreach ($ComputerName in $ComputerNameList)
    {
      $Services = get-MuNonStandardServices $ComputerName

      $Services | select-object state,
                                startmode,
                                @{
                                  Label = 'Startcommand'
                                  Expression = {
                                      'invoke-command -computername ' +
                                      $ComputerName +
                                      ' -script {start-service -name ' +
                                      $_.Name +
                                      '}' }
                                }
    }
    $ServicesToOutput | Sort-Object -property state, startmode, StartCommand
  }



}

set-alias sserv show-Munonstandardservices
set-alias gserv get-Munonstandardservices
set-alias smserv show-Munonstandardservices
set-alias gmserv get-Munonstandardservices

