function Get-MtpAdGroupsInCommon {
<#
.SYNOPSIS
	From: https://hkeylocalmachine.com/?p=941
#>
	[CmdletBinding()]
	param (
		[string[]]$SamAccountName
	)

	$DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

	write-startfunction

	#Define list to hold all group names found
	$groups = @();

	# Loop through each username
	foreach ($user in $SamAccountName) {

		# get the users group memberships
		$usergroups = get-adprincipalgroupmembership $user

		# Append the list of groups names to the master group list
		$groups = $groups + $usergroups.name;

	}

	# Group and count occurrences of each group name where the count matches the number of users
	$groups | group-object | Where-Object {$_.count -eq $samaccountname.count} | Sort-Object name | Select-Object name

	write-endfunction


}
set-alias Get-MAdGroupsInCommon Get-MtpAdGroupsInCommon