function get-MuADUser {
    <#
.SYNOPSIS
    Get AD User, but exclude the certificates property
.DESCRIPTION
    Get AD User, but exclude the certificates property
.EXAMPLE

#>
    [CmdletBinding()]
    Param( [parameter(Position = 0)][string]$NameString,
        $EmployeeNumber,
        $Ou,
        [ValidateSet('Disabled', 'Leavers', 'LeaversPendingDeletion', 'Investigate', 'Mat', 'Employees')]$OuShortName,
        $CanonicalName,
        [switch]$OLoginIsWorking,
        [switch]$OLoginIsWorkingPlusCreated,
        [switch]$OEverythingExceptTheCertificate,
        [switch]$OEverythingExceptTheBoringBits,
        [switch]$OOneScreen,
        [switch]$OCanonicalName,
        [switch]$OFolders,
        [switch]$ODistinguishedName,
        [switch]$OTimestamps
    )

    DynamicParam {

        $options = @(
            (
                Import-Csv "$ENV:PSParametersFolder\GeneralParameters.csv" |
                    Where-Object Program -EQ 'Get-MuAdUser'
            ).Value
        )

        New-DynamicParam -Name Server -ValidateSet $options -type string

    }
    begin {

        $Server = $PSBoundParameters.Server

    }
    process {


        switch ($OUShortName) {
            'Disabled' {
                $Ou = $(Import-Csv "$ENV:PSParametersFolder\GeneralParameters.csv" | Where-Object Parameter -EQ 'GmauDisabled').Value
        }
            'Leavers' {
                $Ou = $(Import-Csv "$ENV:PSParametersFolder\GeneralParameters.csv" | Where-Object Parameter -EQ 'GmauLeavers').Value
            }
            'LeaversPendingDeletion' {
                $Ou = $(Import-Csv "$ENV:PSParametersFolder\GeneralParameters.csv" | Where-Object Parameter -EQ 'GmauLeaversPendingDeletion').Value
            }
            'Investigate' {
                $Ou = $(Import-Csv "$ENV:PSParametersFolder\GeneralParameters.csv" | Where-Object Parameter -EQ 'GmauInvestigate').Value
            }
            'Mat' {
                $Ou = $(Import-Csv "$ENV:PSParametersFolder\GeneralParameters.csv" | Where-Object Parameter -EQ 'GmauMat').Value
            }
            'Employees' {
                $Ou = $(Import-Csv "$ENV:PSParametersFolder\GeneralParameters.csv" | Where-Object Parameter -EQ 'GmauEmployees').Value
            }
        }

        if (!($Server)) {
            $Server = $(Import-Csv "$ENV:PSParametersFolder\GeneralParameters.csv" |
                    Where-Object Parameter -EQ 'SimplyhealthDC').value
        }


        $QueryString = '*' + $NameString + '*'

        try {
            if ($NameString) {

                if (!($OTimestamps)) {
                    $Details = Get-ADUser -Filter "SamAccountName -like '$QueryString'" -Properties * -Server $Server
                }

                else {
                    $DC = Get-ADDomainController -Filter *
                    $DCCount = $( $DC | measure-object).count
                    write-dbg "`$DCCount: <$DCCount>"

                    $Users = Get-ADUser -Filter "SamAccountName -like '$QueryString'" -Properties SamAccountName |
                        Select-Object SamAccountName

                    $Details = foreach ($D in $Users) {
                        $SamAccountName = $D.SamAccountName
                        write-dbg "`$SamAccountName: <$SamAccountName>"
                        foreach ($C in $DC) {
                            [string]$name = $C.Name
                            write-dbg "`$Name: <$Name>"
                            try {
                            $DCUser = Get-ADUser -Filter "SamAccountName -eq '$SamAccountName'" -Properties * -Server $name
                            write-dbg "`$DCUser: <$DCUser>"
                            $DistinguishedName = $DCUser.DistinguishedName
                            write-dbg "`$DistinguishedName: <$DistinguishedName>"
                            # Add-Member -InputObject $D -Name "$Hostname-xx" -Value xx
                            $DCUser | Select-Object @{L = 'DC'; E = {$name}},
                            @{L = 'BadPasswordTimeReformatted'; E = { [datetime]::FromFileTime($_.badpasswordtime).ToString() + ' - ' + $_.badpasswordtime } },
                            Created                              ,
                            LastBadPasswordAttempt               ,
                            lastLogoff                           ,
                            @{L = 'LastLogonReformatted'; E = { [datetime]::FromFileTime($_.lastlogon).ToString() + ' - ' + $_.lastlogon } } ,
                            LastLogonDate                        ,
                            @{L = 'LastLogonTimestampReformatted'; E = { [datetime]::FromFileTime($_.lastlogontimestamp).ToString()  + ' - ' + $_.lastlogontimestamp }} ,
                            Modified                             ,
                            modifyTimeStamp                      ,
                            msExchWhenMailboxCreated             ,
                            PasswordLastSet                      ,
                            @{L = 'pwdLastSetReformatted'; E = { [datetime]::FromFileTime($_.pwdlastset).ToString()  + ' - ' + $_.pwdlastset }} ,
                            SamAccountName                       ,
                            whenChanged
                            } catch {
                                write-host "Can't retrieve data from $name"
                            }


                        }
                    }
                }
            }
            elseif ($EmployeeNumber) {
                write-dbg "Fetching for employee number(s): <$EmployeeNumber>"
                $Details = @()
                $ADUsers = Get-ADUser -Filter "Name -like '*'" -Properties * -Server $Server
                write-dbg "Got ADUSers"

                foreach ($E in $EmployeeNumber) {
                    write-dbg "Filtering for `$E: <$E>"

                    $D = $ADUsers | Where-Object EmployeeNumber -EQ $E
                    write-dbg "Got `$D: <$D>"

                    $Details += $D
                }

            }
            elseif ($CanonicalName) {

                $ADUsers = Get-ADUser -Filter * -Properties CanonicalName -Server $Server

                $Details = $AdUsers |
                    Where-Object CanonicalName -Like "*$CanonicalName*" |
                    Sort-Object -Property CanonicalName
            }
            elseif ($Ou) {

                $Details = Get-ADUser -Properties * -SearchBase $Ou -Filter * -Server $Server

            }
        }
        catch {
            Write-Error "SHCF06: Couldn't get data from AD"
        }


        if ($OLoginIsWorking) {
            foreach ($D in $Details) {
                [string]$Boss = $D.Manager
                $Boss = $Boss.split(',')[0]


                [PSCustomObject] @{ EmployeeNumber = $D.EmployeeNumber
                    samaccountname                 = $D.samaccountname
                    Name                           = $D.Name
                    # Created =$D.Created
                    LastLogonDate                  = $D.LastLogonDate
                    LockedOut                      = $D.LockedOut
                    Enabled                        = $D.Enabled
                    PasswordExpired                = $D.PasswordExpired

                    Boss                           = $Boss

                    telephonenumber                = $D.telephonenumber
                }
            }
        }

        elseif ($OLoginIsWorkingPlusCreated) {
            foreach ($D in $Details) {
                [string]$Boss = $D.Manager
                $Boss = $Boss.split(',')[0]


                [PSCustomObject] @{ EmployeeNumber = $D.EmployeeNumber
                    samaccountname                 = $D.samaccountname
                    Name                           = $D.Name
                    telephonenumber                = $D.telephonenumber
                    Boss                           = $Boss
                    Created                        = $D.Created
                    LastLogonDate                  = $D.LastLogonDate
                    LockedOut                      = $D.LockedOut
                    Enabled                        = $D.Enabled
                    PwExp                          = $D.PasswordExpired
                    DistinguishedName              = $D.DistinguishedName
                    Manager                        = $D.Manager
                }
            }
        }


        elseif ($OEverythingExceptTheCertificate) {
            $Details | Select-Object -Property * -ExcludeProperty userCertificate
        }

        elseif ($OEverythingExceptTheBoringBits) {
            $Details | Select-Object AccountLockoutTime,
            CanonicalName,
            codePage,
            Company,
            Created,
            Deleted,
            Department,
            Description,
            DisplayName,
            DistinguishedName,
            Division,
            EmailAddress,
            EmployeeID,
            EmployeeNumber,
            Enabled,
            HomeDirectory,
            homeMDB,
            homeMTA,
            LastBadPasswordAttempt,
            lastLogon,
            LastLogonDate,
            lastLogonTimestamp,
            legacyExchangeDN,
            LockedOut,
            lockoutTime,
            logonCount,
            LogonWorkstations,
            mail,
            mailNickname,
            Manager,
            MemberOf,
            MNSLogonAccount,
            MobilePhone,
            Modified,
            modifyTimeStamp,
            msDS-User-Account-Control-Computed,
            msExchALObjectVersion,
            msExchDelegateListBL,
            msExchHomeServerName,
            msExchMailboxGuid,
            msExchMailboxSecurityDescriptor,
            msExchPoliciesIncluded,
            msExchRBACPolicyLink,
            msExchRecipientDisplayType,
            msExchRecipientTypeDetails,
            msExchSafeSendersHash,
            msExchTextMessagingState,
            msExchUMDtmfMap,
            msExchUserAccountControl,
            msExchVersion,
            msExchWhenMailboxCreated,
            Name,
            nTSecurityDescriptor,
            ObjectCategory,
            ObjectClass,
            ObjectGUID,
            objectSid,
            Office,
            OfficePhone,
            Organization,
            OtherName,
            PasswordExpired,
            PasswordLastSet,
            PasswordNeverExpires,
            PasswordNotRequired,
            physicalDeliveryOfficeName,
            PrimaryGroup,
            primaryGroupID,
            PrincipalsAllowedToDelegateToAccount,
            ProfilePath,
            ProtectedFromAccidentalDeletion,
            proxyAddresses,
            SamAccountName,
            ScriptPath,
            showInAddressBook,
            SID,
            sn,
            Surname,
            telephoneNumber,
            textEncodedORAddress,
            Title,
            TrustedForDelegation,
            TrustedToAuthForDelegation,
            UseDESKeyOnly,
            userAccountControl,
            UserPrincipalName,
            uSNChanged,
            uSNCreated,
            whenChanged,
            whenCreated

        }

        elseif ($OOneScreen) {
            $Details | Select-Object AccountLockoutTime,
            AdminDescription,
            CanonicalName,
            Company,
            Created,
            Department,
            Description,
            DisplayName,
            DistinguishedName,
            Division,
            EmailAddress,
            EmployeeNumber,
            Enabled,
            HomeDirectory,
            LastLogonDate,
            LockedOut,
            logonCount,
            mail,
            mailNickname,
            Manager,
            Modified,
            msExchWhenMailboxCreated,
            Name,
            ObjectCategory,
            ObjectClass,
            Office,
            PasswordExpired,
            PasswordLastSet,
            PasswordNeverExpires,
            physicalDeliveryOfficeName,
            PrimaryGroup,
            ProfilePath,
            SamAccountName,
            SID,
            Surname,
            telephoneNumber,
            Title,
            UserPrincipalName

        }

        elseif ($OFolders) {
            $Details | Select-Object samaccountname,
            EmployeeNumber,
            mailnickname,
            ProfilePath,
            HomeDirectory
        }
        elseif ($OCanonicalName) {
            $Details | Select-Object samaccountname,
            CanonicalName
        }

        elseif ($ODistinguishedName) {
            $Details | Select-Object samaccountname,
            DistinguishedName
        }
        elseif ($OTimestamps) {
            $Details
        }
        else {
            $Details | Select-Object samaccountname,
            EmployeeNumber,
            Created,
            LastLogonDate,
            LockedOut,
            Enabled,
            PasswordExpired,
            CanonicalName
        }


    }

}
Set-Alias Get-MadUser Get-MuAdUser
Set-Alias gmu Get-MuAdUser
Set-Alias gmau Get-MuAdUser
Set-Alias gau Get-MuAdUser

