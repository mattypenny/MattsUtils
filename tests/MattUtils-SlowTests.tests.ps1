Describe "The slow tests for mattsutils" {
    BeforeAll {
        Import-Module -Force MattsUtils
        . $Env:PsRoot\modules\MattsUtils\tests\SetUpVariables.ps1
    }


    Context get-MuAvailableUpdates {

        It "returns a sensible number of objects" {
            $Actual = get-MuAvailableUpdates -computername $ComputerName
            $Actual.length | Should -BeLessThan 20

        }
    }

    Context Get-MuAdDomainControllers {

        It "returns a sensible number of objects" {
            $Actual = Get-MuAdDomainControllers
            $Actual.length | Should -BeGreaterThan 0
            $Actual.length | Should -BeLessThan 10
        }
    }

    Context Get-MuEventLog2 {

        It "returns a sensible number of objects" {
            $Actual = Get-mueventlog2 -ComputerName $ComputerName -AroundTime $(get-date).addminutes(-5) -Logname Security
            $Actual.length | Should -BeGreaterThan 0
            $Actual.length | Should -BeLessThan 5

        }
    }

}
