The intention of this module is that it's going to combine SQLStuff, WindowsStuff, PersonalStuff and maybe bits of other things like SHCommonFunctions and Checksystems

Anything in here should be:
* sterile i.e. no server names etc
* pwsh7 compatible

Done - in MattsUtils

name                                    synopsis
----                                    --------
Format-MattsColumns                     select hard-coded properties for a given object
Get-MtpAdGroup                          Group names matching string
Get-MtpAdGroupsInCommon                 From: https://hkeylocalmachine.com/?p=941
get-MtpADUser                           Get AD User, but exclude the certificates property
get-MtpComputerUsers                    Get local users of computer (windows powershell oonly)
Get-MTPGitAddAndRemoveCommands          Generates a 'git add' or 'git rm' commands for folder
get-MTPGitStatusAsObjects               reformat git outpur as an object
get-MTPHistory                          Search through history (alias hh)
get-MTPSavePAthHistory                  Search through savepath history (alias hhh)
Get-ProbableObjectType                  have a stab at working out what object it is
Get-ShCommandDefinition                 get the definition out of gcm (alias showme)
Get-ShCommandExcludingSomeModules       Get-ShCommandExcludingSomeModules
get-ShCommandFromSpecifiedModules       Get command for one module, defaulting to dbatools
get-ShCommentBasedHelpFromModule        Get all the help for all the functions in specified modules
get-ShContentFromLastFile               Show content of last file for filespec (alias gcflf)
get-ShContentFromLastFileTailAndWait    Show content of last file for filespec (alias tflf)
Get-ShGeneratedDescribesForEachFunction Generate pester describes...not sure if it's very useful
get-ShGeneratedParameterDebugLines      Generate write-debug lines for a call to a function
Get-ShGeneratedPesterPropertyChecks     Generate pester should be's for each property of a specified object
Get-ShGeneratedPSCustomObjectFromObject Generate a [PSCustomObject] for a specified object
get-ShGeneratedSplatLines               Generate splat command for a specified function
Get-ShGitFoldersWithUnpushedChanges     look for unpushed files in git folders
Invoke-MTPGitAddCommitPush              Add, commit with a message per file and push (alias ggacx)
invoke-MtpGitDiff                       Git diff for all the files in a folder
Invoke-MTPGitDiffAddCommit              Git diff, add, commit and push for each file in a folder (alias gd…
Select-MattsColumns                     select hard-coded properties for a given object (alias fm)

Todo - SHCommonFunctions

SHCommonFunctions       backup-ShFileToOldFolder                           ÔÇª
SHCommonFunctions       export-ShADUser                                    ÔÇª
SHCommonFunctions       format-ShAdUser                                    ÔÇª
SHCommonFunctions       get-IPAddressFromPing                              ÔÇª
SHCommonFunctions       get-ShADUser                                       {ÔÇª
SHCommonFunctions       Get-ShEmailList                                    Get the poor souls who are going to get the email
SHCommonFunctions       Get-ShFirstDayOfThemonth                           ÔÇª
SHCommonFunctions       Get-ShGeneralParameter                             xx
SHCommonFunctions       get-SHLastUsersOnThePc                             ÔÇª
SHCommonFunctions       Get-ShLocalComputerName                            ÔÇª
SHCommonFunctions       get-ShLocalUsers                                   Get local users of computer (windows powershell oonly)
SHCommonFunctions       Get-ShLocation                                     ÔÇª
SHCommonFunctions       Get-ShNameFromIPAddress                            ÔÇª
SHCommonFunctions       get-SHPhoneNumber                                  ÔÇª
SHCommonFunctions       get-ShServersFromAD                                ÔÇª
SHCommonFunctions       get-SHUsersFromUsersFolder                         ÔÇª
SHCommonFunctions       show-ShServersFromAD                               ÔÇª
SHCommonFunctions       write-countobject                                  ÔÇª
SHCommonFunctions       write-dbg                                          write-dbg with function and time stamp
SHCommonFunctions       write-endfunction                                  Marks end of function in logfile or debug output
SHCommonFunctions       write-ShDebug                                      ÔÇª
SHCommonFunctions       write-ShHost                                       ÔÇª
SHCommonFunctions       write-ShVerbose                                    ÔÇª
SHCommonFunctions       write-startfunction                                Marks start of function in logfile or debug output

Todo - SqlStuff

SqlStuff                Find-Columns                                       xx
SqlStuff                format-sqlping                                     Connect to specified sql and returns edition, version, last re-start time, and formats results
SqlStuff                Get-AllSchemas                                     ÔÇª
SqlStuff                Get-AllTableColumns                                xx
SqlStuff                Get-AllTableColumnsMatching                        xx
SqlStuff                get-DeOrphanScript                                 Generates a de-orphanning script for specified instance, and all the databases matching a string e.g. 'uft%'
SqlStuff                Get-MtpAllLastBackups                              xx
SqlStuff                Get-MtpDbaAgentJob                                 xx
SqlStuff                Get-MTPDbaAgentJobAsMarkdown                       xx
SqlStuff                Get-MtpLastBackupSummary                           xx
SqlStuff                Get-ShAllDbAccess                                  xx
SqlStuff                Get-ShDatabaseExtendedProperties                   ÔÇª
SqlStuff                Get-ShTableColumns                                 ÔÇª
SqlStuff                Get-ShTables                                       ÔÇª
SqlStuff                get-sp_whoisactivehelptext                         ÔÇª
SqlStuff                get-sqlserverfiles                                 List all sqlserver data and log files for an instance, with various options
SqlStuff                get-SqlTableIndexes                                Gets Sql Table indexes
SqlStuff                get-SqlTableSizingForDatabase                      Gets tablesizings with sp_msforeachtable 'EXEC sp_spaceused [?]'
SqlStuff                invoke-InsertAMillionRows                          Inserts a million rows into a table called logtest into s specified database (used for testing stuff)
SqlStuff                Invoke-SelectFoundColumns                          xx
SqlStuff                invoke-sp_who                                      Just runs sp_who for the specified instance and, optionally, database
SqlStuff                invoke-sp_whoisactive                              Just runs sp_whoisactive for the specified instance
SqlStuff                Invoke-SqlNotebook                                 ÔÇª
SqlStuff                invoke-sqlping                                     Connect to specified sql instance and returns edition, version, last re-start time
SqlStuff                New-DummyTables                                    ÔÇª
SqlStuff                Restart-ShSQLWriter                                Re-starts the SQLWriter service on the specified server
SqlStuff                run-sql                                            Hopefully unused script that runs invoke-sqlcmd
SqlStuff                Set-ShSqlDbExtendedProperties                      Sets DateAdded to today and descriptio to whatever you specify
SqlStuff                sfiles                                             Runs get-sqlserverfiles
SqlStuff                show-allsqlconnections                             Same as test-allsqlconnections but with ft -a
SqlStuff                show-sp_whoisactive                                Just runs sp_whoisactive for the specified instance
SqlStuff                show-sp_whoisactive2                               Just runs sp_whoisactive for the specified instance
SqlStuff                show-sqlsize                                       ÔÇª
SqlStuff                show-sqlsizeperdisk                                Gets amount of space used by an instance per disk
SqlStuff                SQLSERVER:                                         ÔÇª
SqlStuff                test-allsqlconnections                             Connect to all sqlservers (as listed in data\ServerInstances.csv ) and returns edition, version, etc. Fast way tÔÇª

Todo - StandardScriptFunctions

StandardScriptFunctions copy-SsfAttachmentsToBeEmailFriendly               ÔÇª
StandardScriptFunctions Get-SsfParameter2                                  Get parameter from parameters file, with an optional program value
StandardScriptFunctions New-DynamicParam                                   Helper function to simplify creating dynamic parameters
StandardScriptFunctions New-SsfFolderForFileName                           Create containing folder for given filename
StandardScriptFunctions Show-SsfInformation                                Until I can find a way of turning write-information green, this does a write-host. Sue me. :)
StandardScriptFunctions write-dbg                                          write-dbg with function and time stamp
StandardScriptFunctions write-DbgPsBoundParameters                         Write all the parameters to debug
StandardScriptFunctions write-dbgPsObject                                  ÔÇª
StandardScriptFunctions write-Ssfendfunction                               Marks end of function in logfile or debug output
StandardScriptFunctions write-SsfError                                     xx
StandardScriptFunctions Write-SSfLog                                       Write formatted message to csv logfile
StandardScriptFunctions write-Ssfstartfunction                             Marks start of function in logfile or debug output

Todo - WindowsStuff

WindowsStuff            enable-sqlserver_dba                               Sets up a serverinstance for access by the sqlserver_dba group and monitor_sql_service [sh]
WindowsStuff            Get-AclPlus                                        Gets permissions for folders, and optionally files, and optionally expands the groups
WindowsStuff            Get-ADDirectReports                                This function retrieve the directreports property from the IdentitySpecified.ÔÇª
WindowsStuff            get-AvailableUpdates                               ÔÇª
WindowsStuff            Get-ChildItemSizeGroupedByTimeInterval             xx
WindowsStuff            get-ComputerSummary                                Get summary for specified computer
WindowsStuff            get-EventsFromPC                                   Gets occurences of specified eventid from a range
WindowsStuff            Get-InstalledSoftware                              Gets a list of programs from the registry Uninstall key
WindowsStuff            get-LineFromSimplyhealthQuickReferenceFiles        Does a grep on quickref files
WindowsStuff            Get-MadUsersWithinGroups                           xx
WindowsStuff            Get-MemoryUsage                                    ÔÇª
WindowsStuff            get-MTPEventLog                                    Displays the eventlog a bit more prettier than get-eventlog does out of the box
WindowsStuff            Get-MtpEventLog2                                   xx
WindowsStuff            Get-NfsPermissionsForSharesForComputer             Gets permissions for shares for a specified computer
WindowsStuff            get-nonstandardprograms                            Gets a list of programs deemed as non-standard or 'distinctive'
WindowsStuff            get-nonstandardservices                            Gets a list of services deemed as non-standard or 'distinctive'
WindowsStuff            get-OldShScheduledTasks                            ÔÇª
WindowsStuff            get-physicalorvirtual                              ÔÇª
WindowsStuff            Get-PreviousReboots                                Shows all the reboots recorded in the eventlog
WindowsStuff            get-processordetails                               Gets processor details
WindowsStuff            get-serversize                                     Gets drive sizings
WindowsStuff            Get-ShAdDomainControllers                          ÔÇª
WindowsStuff            Get-ShADOrganizationalUnit                         Get canonical names of OUs in alphabetical order, so you can see structure
WindowsStuff            Get-ShADUsersInGroupsUnderOU                       ÔÇª
WindowsStuff            Get-ShAllADUsers                                   xx
WindowsStuff            Get-ShAllEvents                                    ÔÇª
WindowsStuff            get-share                                          ÔÇª
WindowsStuff            get-ShCpuUsage                                     Show CPU usage over specified intervals
WindowsStuff            Get-ShGeneralParameter                             xx
WindowsStuff            get-SHLocalSids                                    ÔÇª
WindowsStuff            Get-ShLocalUsersOnServers                          ÔÇª
WindowsStuff            Get-ShScheduledTasks                               ÔÇª
WindowsStuff            Get-ShUsersInOu                                    ÔÇª
WindowsStuff            Get-Snippet                                        xx
WindowsStuff            get-SoftwareListFromProgramFiles                   Gets a list of programs from c:\program files
WindowsStuff            get-sqlerrorlog                                    Get the most recent sqlerrorlog messagesÔÇª
WindowsStuff            get-tnsnamesproperties                             Gets the aliases out of the tnsnames file[SH]
WindowsStuff            Get-TopProcesses                                   Gets top windows processes on specified server
WindowsStuff            get-WSLocalGroupMemberShip                         Gets local admins on a specified server
WindowsStuff            grant-LocalAdmin                                   Grant local admin on specified server to specified group or user
WindowsStuff            grant-ShAllDbaPrivilegesOnEstate                   ÔÇª
WindowsStuff            grant-ShAllDbaPrivilegesOnServer                   Sets up a login with sa on the instance and local admin on the sever
WindowsStuff            invoke-PesterLoop                                  Continuously run pester tests. Output green do if all OK. Display errpr of not.
WindowsStuff            invoke-sp_helptext                                 Just runs sp_helptext for the specified instance and, optionally, database
WindowsStuff            New-DrInformationSet                               Dump server info to a file
WindowsStuff            New-ShLocalAdminUser                               xx
WindowsStuff            show-cpu                                           ÔÇª
WindowsStuff            show-foldersize                                    Recursively gets size of folders (but doesn't accumulate) [SH]
WindowsStuff            show-nonstandardprograms                           Gets and format a list of Programs deemed as non-standard or 'distinctive'
WindowsStuff            show-nonstandardservices                           Gets and format a list of services deemed as non-standard or 'distinctive', with options for properties shown
WindowsStuff            show-odbc                                          ÔÇª
WindowsStuff            show-physicalorvirtual                             ÔÇª
WindowsStuff            show-serversize                                    Gets drive sizings and formats them
WindowsStuff            show-sharepermissions                              ÔÇª
WindowsStuff            show-SimplyHealthquickref                          Does a grep on quickref files
WindowsStuff            show-sqlorphanedusers                              
WindowsStuff            show-TopProcesses                                  Shows top windows processes on specified server
WindowsStuff            sos                                                ÔÇª
WindowsStuff            Start-SHService                                    ÔÇª
WindowsStuff            template                                           Template for Powershell functions
WindowsStuff            Test-ShNetConnectionAddMemberTime                  ÔÇª
WindowsStuff            Test-ShNetConnectionOverTime                       ÔÇª
WindowsStuff            test-ShServerIsUp                                  ÔÇª
WindowsStuff            write-dbg                                          write-dbg with function and time stamp


