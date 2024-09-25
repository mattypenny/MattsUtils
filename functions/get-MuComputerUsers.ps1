<#
.SYNOPSIS
    Get local users of computer (windows powershell oonly)
.DESCRIPTION
    Longer description
.EXAMPLE
    Example of how to use this cmdlet
#>
function get-MuComputerUsers {
        [CmdletBinding()]
        Param
            (
                [Parameter(Mandatory=$true,
                           ValueFromPipelineByPropertyName=$true,
                           Position=0)]
                $ComputerName

            )

        $LocalUsers = @()

        $ComputerNameList = $ComputerName

        foreach ($ComputerName in $ComputerNameList)
        {
            write-verbose "========================================="
            write-verbose "processing $ComputerName"

            $Groups = Get-WmiObject -ComputerName $ComputerName -class win32_group -filter "Domain = '$ComputerName'"

            foreach ($Group in $Groups)
            {

                write-verbose "  Processing Server <$ComputerName> Group <$($Group.name)>"
                $users = get-wmiobject -ComputerName $ComputerName -query "select * from win32_groupuser where GroupComponent = `"Win32_Group.Domain='$ComputerName'`,Name='$($Group.name)'`""
                [array]$UsersList = $Users.partcomponent
                if ($users -eq $null)
                {
                    write-verbose "    no users in $($Group.name)"
                }

                Else
                {
                    foreach ($User in $UsersList)
                    {

                        $UsersList = $User.replace("Domain="," , ").replace(",Name=","\").replace("\\",",").replace('"','').split(",")
                        $User = $UsersList[2]
                        $User = $User.trim()

                        write-verbose "    User $User in $($Group.name)"

                        $LocalUsers += New-Object PSObject -Property @{
                            ComputerName = $ComputerName
                            Group = ($Group.name)
                            Username = [string]$User
                            }
                    }
                }
            }

            #     $LocalUsers | where-object computer -eq $ComputerName | select-object computer,group,users | Export-CSv -path $ServerCsvFile -NoTypeInformation
        }

        $LocalUsersCount = $LocalUsers.count
        write-verbose "`$LocalUsers : <$LocalUsers>"

                $LocalUsers | sort-object -property ComputerName, Username, Group

    }

    set-alias get-MuLocalUsers get-MuComputerUsers