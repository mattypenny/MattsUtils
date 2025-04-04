function Select-MuColumns {
    <#
.SYNOPSIS
    select hard-coded properties for a given object (alias fm)
#>
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipeline = $true)]
        $PipelineInput
    )
    begin {
        $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

    }


    process {

        $FirstObject = $PipelineInput | Select-Object -First 1
        $FirstObjectCount = $( $FirstObject | Measure-Object).count
        write-dbg "`$FirstObjectCount: <$FirstObjectCount>"

        $Members = $($FirstObject | Get-Member)
        $MembersCount = $( $Members | Measure-Object).count
        write-dbg "`$MembersCount: <$MembersCount>"

        $FirstMember = $Members | Select-Object -First 1
        $FirstMemberCount = $( $FirstMember | Measure-Object).count
        write-dbg "`$FirstMemberCount: <$FirstMemberCount>"

        [string]$TypeName = $FirstMember.TypeName

        write-dbg "`$TypeName: <$TypeName>"

        $P = $PipelineInput
        $Output = switch ($TypeName) {
            'Pester.Run' {
                $P |
                    select-object -ExpandProperty Tests |
                    where-object Passed -eq $False |
                    select-object Passed, ExpandedName |
                    sort-object Passed,ExpandedName
            }

            'Microsoft.SqlServer.Management.Smo.Agent.Job' {
                $P | Select-Object sqlinstance, name, currentrunstatus, lastrundate, lastrunoutcome, nextrundate
            }
            'Microsoft.SqlServer.Management.Smo.Login' {
                $P | Select-Object sqlinstance, name, logintype, state, IsDisabled, IsLocked, CreateDate, LastLogin, defaultdatabase
            }
            'Microsoft.SqlServer.Management.Smo.Database' {
                $P | Select-Object sqlinstance, name, lastfullbackup, lastlogbackup, createdate,
                @{Label = "SzMb"; Expression = { [math]::Round($_.SizeMb, 0 ) } }, owner, RecoveryModel
            }
            'Sqlcollaborative.Dbatools.Database.BackupHistory' {
                $P | Select-Object sqlinstance, database, TotalSize,
                @{L = 'CompSz'; E = { $_.CompressedBackupSize } },
                @{L = 'Ratio'; E = { $_.CompressionRatio } },
                DeviceType, start, end, duration, path
            }
            'Microsoft.SqlServer.Management.Smo.Agent.JobStep' {
                $P | Select-Object sqlinstance, agentjob, id, Name, lastrundate, lastrunduration, lastrunoutcome, Command | Sort-Object -Property agentjob, id
            }
            'dbatools.AgentJobHistory' {
                $P | Select-Object sqlinstance,
                job,
                StepName,
                rundate,
                StartDate, EndDate,
                # Duration,
                Status | #,
                    # Message|
                    Sort-Object -Property Rundate
            }
            'System.IO.DirectoryInfo' {
                $P | Select-Object lastwritetime, length, fullname
            }
            'System.IO.FileInfo' {
                $P | Select-Object lastwritetime, length, fullname
            }
            'Microsoft.Graph.PowerShell.Models.MicrosoftGraphSignIn' {

                $Location = $P | select -ExpandProperty Location
                $Where = $Location.city

                $Status = $P | Select-Object -ExpandProperty Status
                $ErrorCode = $Status.Errorcode
                $FailureReason = $Status.FailureReason

                $P | Select-Object @{
                    Label = 'AppDisplayName'
                    Expression = {
                        $_.AppDisplayName -replace 'Command Line Tools','CLI' -replace 'Office365','O365'
                    }
                },
                @{ Label = 'ClientAppUsed'
                    Expression = {
                        $_.ClientAppUsed -replace 'Mobile Apps and Desktop Clients', 'Mobile/Desktop'
                    }
                },
                @{Label = 'CStatus'
                    Expression = {$_.ConditionalAccessStatus}
                },
                CreatedDateTime,
                @{
                    Label = 'Where'
                    Expression = {$Where}
                },
                @{ Label = 'ResourceDisplayName'
                    Expression = {
                        $_.ResourceDisplayName -replace 'Windows Azure', 'Az'
                    }
                },
                UserPrincipalName,
                @{
                    Label = 'Error'
                    Expression = {
                        $ErrorCode
                    }
                },
                @{
                    Label = 'FailureReason'
                    Expression = {
                        $FailureReason
                    }
                }
            }

            Default {


                $PSCallStack = Get-PSCallStack
                $StackBeforeLast = $PSCallStack[1]

                [string]$Command = $StackBeforeLast.Command
                write-dbg "`$Command: <$Command>"

                switch ($Command) {
                    'Get-DbaDbFile' {
                        $P | Select-Object SqlInstance,
                        Database,
                        TypeDescription,
                        LogicalName,
                        State,
                        Growth,
                        Size,
                        UsedSpace,
                        PhysicalName
                    }
                    'Get-MuAdUser' {
                        $P | Select-Object samaccountname,
                        LockedOut     ,
                        Enabled       ,
                        PwExp         ,
                        Created       ,
                        LastLogonDate ,
                        Boss          ,
                        EmployeeNumber,
                        DistinguishedName
                    }
                    'Get-RemoteMailbox' {
                        $P | Select-Object RemoteRoutingAddress,
                        RemoteRecipientType,
                        OnPremisesOrganizationalUnit,
                        ExchangeGuid,
                        ArchiveStatus,
                        SamAccountName,
                        UserPrincipalName,
                        ResetPasswordOnNextLogon,
                        WhenMailboxCreated,
                        LitigationHoldEnabled,
                        SingleItemRecoveryEnabled,
                        RetentionHoldEnabled,
                        Alias,
                        CustomAttribute10,
                        CustomAttribute6,
                        DisplayName,
                        PrimarySmtpAddress,
                        RecipientType,
                        RecipientTypeDetails,
                        WindowsEmailAddress,
                        Identity,
                        IsValid,
                        ExchangeVersion,
                        Name,
                        DistinguishedName,
                        Guid,
                        ObjectCategory,
                        WhenChanged,
                        WhenCreated,
                        Id,
                        OriginatingServer,
                        ObjectState
                    }
                    Default {
                        $ProbableObjectType = get-ProbableObjectType -object $P

                        switch ($ProbableObjectType) {
                            'LastLogon' {
                                $P | Select-Object SamAccountName,
                                Company,
                                Enabled,
                                lastLogon,
                                lastLogonAad,
                                Department
                            }
                            'Default' {
                                $P | Select-Object *
                            }

                        }
                    }
                }
            }
        }
        $Output
    }


    end {
    }
}

Set-Alias sm Select-MuColumns

function Get-ProbableObjectType {
<#
.SYNOPSIS
    have a stab at working out what object it is
#>
    [CmdletBinding()]
    param (
        $Object
    )

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

    $Members = $Object | Get-Member

    if (($Members | Where-Object name -eq 'CN') -and
        ($Members | Where-Object name -eq 'DisplayName') -and
        ($Members | Where-Object name -eq 'SamAccountName') -and
        ($Members | Where-Object name -eq 'UserPrincipalName') -and
        ($Members | Where-Object name -eq 'Description') -and
        ($Members | Where-Object name -eq 'Company') -and
        ($Members | Where-Object name -eq 'Department') -and
        ($Members | Where-Object name -eq 'Enabled') -and
        ($Members | Where-Object name -eq 'lastLogon') -and
        ($Members | Where-Object name -eq 'PSComputerName') -and
        ($Members | Where-Object name -eq 'RunspaceId') -and
        ($Members | Where-Object name -eq 'lastLogonAad')) {

            $ProbableObjectType = 'LastLogon'

    }


    return $ProbableObjectType

}

function Format-MuColumns {
    <#
.SYNOPSIS
    select hard-coded properties for a given object
#>
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipeline = $true)]
        $PipelineInput
    )

    begin {
        $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

        $Output = @()
    }


    process {

        $P = $PipelineInput
        $PCount = $( $P | Measure-Object).count
        write-dbg "`$PCount: <$PCount>"

        $Output += $P | Select-MuColumns

        $OutputCount = $( $Output | Measure-Object).count
        write-dbg "`$OutputCount: <$OutputCount>"

    }
    end {
        $Output | Format-Table -AutoSize

    }
}
Set-Alias fm Format-MuColumns

