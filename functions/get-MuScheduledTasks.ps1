function Get-MuScheduledTasks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,
        [Parameter(Mandatory = $false)]
        [string]$Pattern = '*',
        [switch]$ShowCommand = $True,
        [switch]$ShowStartCommand = $True,
        [switch]$ExcludeStandardStuff = $True
    )

    $StandardTasks = (
        'Server Initial Configuration Task',
        '.NET Framework NGEN v4.0.30319',
        '.NET Framework NGEN v4.0.30319 64',
        '.NET Framework NGEN v4.0.30319 64 Critical',
        '.NET Framework NGEN v4.0.30319 Critical',
        'ProgramDataUpdater',
        'Pre-staged app cleanup',
        'BitLocker Encrypt All Drives',
        'BitLocker MDM policy Refresh',
        'SyspartRepair',
        'CreateObjectTask',
        'Device',
        'DXGIAdapterCache',
        'Diagnostics',
        'StorageSense',
        'EDP App Launch Task',
        'EDP Auth Task',
        'EDP Inaccessible Credentials Task',
        'StorageCardEncryption Task',
        'ScanForUpdates',
        'ScanForUpdatesAsUser',
        'SmartRetry',
        'WakeUpAndContinueUpdates',
        'WakeUpAndScanForUpdates',
        'Notifications',
        'WindowsActionDialog',
        'SystemSoundsService',
        'LoginCheck',
        'Registration',
        'StartComponentCleanup',
        'Account Cleanup',
        'Collection',
        'Configuration',
        'SpaceManagerTask',
        'HeadsetButtonPress',
        'SpeechModelDownloadTask',
        'MsCtfMonitor',
        'Backup Scan',
        'Maintenance Install',
        'MusUx_UpdateInterval',
        'Reboot',
        'Schedule Scan',
        'Scheduled Start',
        'Automatic-Device-Join',
        'Recovery-Check',
		'Office 15 Subscription Heartbeat',
		'OfficeTelemetryAgentFallBack',
		'OfficeTelemetryAgentLogOn',
		'EnableErrorDetailsUpdate',
		'ErrorDetailsUpdate',
		'Server Manager Performance Monitor',
		'ApplicationsSupportCheck',
		'ApplicationsSupportCheckAlwaysEmail',
		'CleanupOldPerfLogs',
		'BackgroundUploadTask',
		'BackupTask',
		'NetworkStateChangeTask',
		'Policy Install',
		'Resume On Boot',
		'USO_UxBroker_Display',
		'USO_UxBroker_ReadyToReboot',
		'Windows Defender Cache Maintenance',
		'Windows Defender Cleanup',
		'Windows Defender Scheduled Scan',
		'Windows Defender Verification',
        'MicrosoftEdgeUpdateTaskMachineCore',
        'MicrosoftEdgeUpdateTaskMachineUA'
    )

    $ComputerNameList = $ComputerName

    [string]$ComputerName = ""
    foreach ($computerName in $ComputerNameList) {
        $Cimsession = new-cimsession -computername $computerName

        $tasks = Get-ScheduledTask -CimSession $cimsession |
            Where-Object {$_.TaskName -like $Pattern} |
            Where-Object Author -notin (
                'Microsoft',
                'Microsoft Corporation',
                'Trend Micro, Inc.',
                'Microsoft Corporation.'
            ) |
            Where-Object TaskName -notin $StandardTasks
        remove-cimsession $CimSession

        foreach ($task in $tasks) {

            $taskName = $task.TaskName
            $taskPAth = $task.TaskPAth
            $Author = $task.Author
            $User = $task.User
            $State = $task.State
            $Principal = $task.Principal

            $Cimsession = new-cimsession -computername $computerName
            $taskInfo = Get-ScheduledTaskInfo -TaskName $TaskName -TaskPath $TaskPath -cimsession $cimsession
            remove-cimsession $CimSession

            $nextRunTime = $taskInfo.NextRunTime
            $lastRunTime = $taskInfo.LastRunTime

            if ($ShowCommand) {
                $Actions = $Task | Select-Object -expand Actions
                $Command = ""
                foreach ($A in $Actions) {
                    $Execute = $A.Execute
                    $Arguments = $A.Arguments
                    $Command = $Command + "$Execute $Arguments ; "
                }
            }

            if ($ShowStartCommand) {
                $startCommand = @"
Start-ScheduledTask -TaskPath '$($task.TaskPath)' -TaskName '$($task.TaskName)' -cimsession `$(new-cimsession -ComputerName $ComputerName)
"@
            }

            [PSCustomObject]@{
                ComputerName = $computerName
                Path = $task.TaskPath
                Name = $taskName
                NextRunTime = $nextRunTime
                LastRunTime = $lastRunTime
                Author = $Author
                User = $Principal.UserId
                State = $State
                Command = $(if ($ShowCommand) { $command })
                StartCommand = $(if ($ShowStartCommand) { $startCommand })
            }
        }
        if ($(get-cimsession)) {
            try {
                get-cimsession | remove-cimsession
            } catch {

            }
        }
    }
}
