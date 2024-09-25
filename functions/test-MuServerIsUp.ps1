function test-MuServerIsUp
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        $ComputerName,
        [int]$Count = 2
    )

    Begin
    {
    }
    Process
    {
        $ListOfComputerNames = $ComputerName

        for ($i=0; $i -lt $count; $i++)
        {
            foreach ($ComputerName in $ListOfComputerNames)
            {
                $DiskVisible = $False
                $Pingable = $False
                $LastBt = $null
                $booted = $null

                if (test-connection $ComputerName -Count 1 -Quiet -timeout 2 )
                {

                    $Pingable = $True

                    if (dir \\$ComputerName\c$ -ErrorAction SilentlyContinue )
                    {
                        $DiskVisible = $True

                        $WmiObject = get-ciminstance -class win32_operatingsystem -computer $ComputerName -ErrorAction SilentlyContinue
                        if ($WmiObject  )
                        {
                            $Booted = $WmiObject.lastbootuptime
                        }

                    }
                }






                [PSCustomObject]@{
                   ComputerName = $ComputerName
                   Pingable = $Pingable
                   DiskVisible =  $DiskVisible
                   Booted = $Booted
                   }

            }

            start-sleep -seconds 1
        }

    }
    End
    {
    }
}
set-alias upyet test-MuServerIsUp
set-alias test-ShServerIsUp test-MuServerIsUp

