Describe "All of mattsutils" {
    BeforeAll {
        Import-Module -Force MattsUtils
        . $Env:PsRoot\modules\MattsUtils\tests\SetUpVariables.ps1
    }


    Context Get-MuAclPlus {

        It "returns a sensible number of objects" {
            $Actual = Get-MuAclPlus C:\temp
            $Actual.length | Should -BeGreaterThan 20
            $Actual.length | Should -BeLessThan 70
        }
    }


    Context get-MuAdGroup {

        It "returns a sensible number of objects" {
            $Actual = get-MuAdGroup DBA
            $Actual.length | Should -BeGreaterThan 5
            $Actual.length | Should -BeLessThan 30
        }
    }

    Context Get-MuADGroupsInCommon {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            # $Actual = Get-MuADGroupsInCommon -computername $ComputerName
            #    $Actual.length | Should -BeGreaterThan 22
            #     $Actual.length | Should -BeLessThan 222

        }
    }

    Context Get-MuADOrganizationalUnit {

        It "returns a sensible number of objects" {
            $Actual = Get-MuADOrganizationalUnit
            $Actual.length | Should -BeGreaterThan 200
            $Actual.length | Should -BeLessThan 2220

        }
    }

    Context get-MuADUser {

        It "returns a sensible number of objects" {
            $Actual = get-MuADUser matt*
            $Actual.length | Should -BeGreaterThan 2
            $Actual.length | Should -BeLessThan 22

        }
    }


    Context Get-MuChildItemSizeGroupedByTimeInterval {

        It "returns a sensible number of objects" {
            $Actual = Get-MuChildItemSizeGroupedByTimeInterval ~
            $Actual.length | Should -BeGreaterThan 10
            $Actual.length | Should -BeLessThan 20

        }
    }

    Context Get-MuCommandDefinition {

        It "returns a sensible number of objects" {
            [string]$Actual = Get-MuCommandDefinition Get-MuCommandDefinition
            $Actual.length | Should -BeGreaterThan 400
            $Actual.length | Should -BeLessThan 1000
        }

        It "includes the string 'get the definition out of gcm (alias showme)'" {

            [string]$Actual = Get-MuCommandDefinition Get-MuCommandDefinition
            $Actual.Contains('get the definition out of gcm (alias showme)') | Should -be $True
        }
    }

    Context Get-MuCommandExcludingSomeModules {

        It "returns a sensible number of objects i.e. the Azure stuff" {

            $Actual = Get-MuCommandExcludingSomeModules -name user
            $Actual.length | Should -BeGreaterThan 22
            $Actual.length | Should -BeLessThan 50

        }
    }

    Context get-MuCommandFromSpecifiedModules {

        It "returns a sensible number of objects" {
            $Actual = get-MuCommandFromSpecifiedModules -Name user -Module MattsUtils,ActiveDirectory
            $Actual.length | Should -BeGReaterThan 10
            $Actual.length | Should -BeLessThan 22
        }
    }

    Context get-MuCommentBasedHelpFromModule {

        It "returns a sensible number of objects" {
            $Actual = get-MuCommentBasedHelpFromModule -Module MattsUtils
            $Actual.length | Should -BeGreaterThan 60
            $Actual.length | Should -BeLessThan 222

        }
    }

    Context Get-MuComputerSummary {

        It "returns a sensible number of objects" {
            $Actual = Get-MuComputerSummary -computername $ComputerName
            $Actual.length | Should -Be 1
        }
    }

    Context get-MuComputerUsers {

        It "returns a sensible number of objects" {
            $Actual = get-MuComputerUsers -computername $ComputerName
            $Actual.length | Should -BeGreaterThan 30
            $Actual.length | Should -BeLessThan 40

        }
    }

    Context get-MuContentFromLastFile {

        It "returns a sensible number of objects" {
            $LastFile = 'c:\temp\test1.txt'
            set-content -path $LastFile -value "Kanban says no"
            $Actual = get-MuContentFromLastFile C:\temp
            $Actual.length | Should -Be 14
        }
    }

    <#
        Can't really test this
    Context get-MuContentFromLastFileTailAndWait {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            # $Actual = get-MuContentFromLastFileTailAndWait -computername $ComputerName
            #    $Actual.length | Should -BeGreaterThan 22
            #     $Actual.length | Should -BeLessThan 222

        }
    }
    #>

    Context Get-MuCpuUsage {

        It "returns a sensible number of objects" {
            $Actual = Get-MuCpuUsage -computername $ComputerName
            $Actual.length | Should -Be 4
        }
    }


    Context Get-MuGeneratedDescribesForEachFunction {

        It "returns a sensible number of objects" {
            $Actual = Get-MuGeneratedDescribesForEachFunction -Module MattsUtils -NameString get-MuHistory
            $Actual.length | Should -BeGreaterThan 190
            $Actual.length | Should -BeLessThan 222

        }
    }

    Context get-MuGeneratedParameterDebugLines {

        It "returns a sensible number of objects" {
             $Actual = get-MuGeneratedParameterDebugLines -function get-MuHistory
                $Actual.length | Should -BeGreaterThan 145
                 $Actual.length | Should -BeLessThan 155

        }
    }

    Context Get-MuGeneratedPesterPropertyChecks {

        It "returns a sensible number of objects" {
            $Actual = $(Get-MuGeneratedPesterPropertyChecks -ObjectName SomeObjectName -Property SomePropertyName)
$Actual.length | Should -BeGreaterThan 99
            $Actual.length | Should -BeLessThan 101

        }
    }

    Context Get-MuGeneratedPSCustomObjectFromObject {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            $Actual = Get-MuGeneratedPSCustomObjectFromObject  -InputObject $(get-childitem) -RightHandSidePrefix Gci
            $Actual.length | Should -BeGreaterThan 1900
            $Actual.length | Should -BeLessThan 2100

        }
    }

    Context get-MuGeneratedSplatLines {

        It "returns a sensible number of objects" {
            $Actual = get-MuGeneratedSplatLines -Function get-childitem
            $Actual.length | Should -BeGreaterThan 450
            $Actual.length | Should -BeLessThan 500

        }
    }

    Context Get-MuGitAddAndRemoveCommands {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            $Actual = Get-MuGitAddAndRemoveCommands
            $Actual.length | Should -BeGreaterThan 1
            $Actual.length | Should -BeLessThan 50

        }
    }

    Context Get-MuGitFoldersWithUnpushedChanges {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            # $Actual = Get-MuGitFoldersWithUnpushedChanges -computername $ComputerName
            #    $Actual.length | Should -BeGreaterThan 22
            #     $Actual.length | Should -BeLessThan 222

        }
    }

    Context get-MuGitStatusAsObjects {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            $Actual = get-MuGitStatusAsObjects
            $Actual.length | Should -BeGreaterThan 1
            $Actual.length | Should -BeLessThan 22

        }
    }

    Context get-MuHistory {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            $Actual = get-MuHistory
            $Actual.length | Should -BeGreaterThan 2
            $Actual.length | Should -BeLessThan 51

        }
    }

    Context Get-MuInstalledSoftware {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            $Actual = Get-MuInstalledSoftware -computername $ComputerName
            $Actual.length | Should -BeGreaterThan 22
            $Actual.length | Should -BeLessThan 222

        }
    }

    Context get-MuNonStandardPrograms {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            $Actual = get-MuNonStandardPrograms -computername $ComputerName
            $Actual.length | Should -BeGreaterThan 22
            $Actual.length | Should -BeLessThan 222

        }
    }

    Context Get-MuNonStandardServices {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            $Actual = Get-MuNonStandardServices -computername $ComputerName
            $Actual.length | Should -BeGreaterThan 22
            $Actual.length | Should -BeLessThan 50

        }
    }

    Context Get-MuPreviousReboots {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            # $Actual = Get-MuPreviousReboots -computername $ComputerName
            #    $Actual.length | Should -BeGreaterThan 22
            #     $Actual.length | Should -BeLessThan 222

        }
    }

    Context get-MuSavePAthHistory {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            # $Actual = get-MuSavePAthHistory -computername $ComputerName
            #    $Actual.length | Should -BeGreaterThan 22
            #     $Actual.length | Should -BeLessThan 222

        }
    }

    Context get-MuScheduledTasks {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            # $Actual = get-MuScheduledTasks -computername $ComputerName
            #    $Actual.length | Should -BeGreaterThan 22
            #     $Actual.length | Should -BeLessThan 222

        }
    }

    Context Get-MuServerSize {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            # $Actual = Get-MuServerSize -computername $ComputerName
            #    $Actual.length | Should -BeGreaterThan 22
            #     $Actual.length | Should -BeLessThan 222

        }
    }

    Context Get-MuShare {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            # $Actual = Get-MuShare -computername $ComputerName
            #    $Actual.length | Should -BeGreaterThan 22
            #     $Actual.length | Should -BeLessThan 222

        }
    }

    Context Get-MuTopProcesses {

        It "returns a sensible number of objects" {
            $Actual = Get-MuTopProcesses -computername $ComputerName
            $Actual.length | Should -BeGreaterThan 5
            $Actual.length | Should -BeLessThan 20
        }
    }

    Context Get-MuUsersInOu {

        It "returns a sensible number of objects" {
            $EmployeesOu = $(import-csv $Env:PsParametersFolder\GeneralParameters.csv | where-object Parameter -eq 'GmauEmployeesOu').Value
            $Actual = Get-MuUsersInOu -SearchBase  $EmployeesOu
            $Actual.length | Should -BeGreaterThan 700
            $Actual.length | Should -BeLessThan 800

        }
    }

    Context Get-MuUsersWithinGroups {

        It "returns a sensible number of objects" {
            $Actual = Get-MuUsersWithinGroups -computername $ComputerName
            $Actual.length | Should -BeGreaterThan 10
            $Actual.length | Should -BeLessThan 20

        }
    }

    <#

    Can't think of a good way of testing this atm
    Context grant-MuLocalAdmin {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            # $Actual = grant-MuLocalAdmin -computername $ComputerName
            #    $Actual.length | Should -BeGreaterThan 22
            #     $Actual.length | Should -BeLessThan 222

        }
    }

    #>

    Context Invoke-MuGitAddCommitPush {

        It "returns a sensible number of objects" {
            $True | Should -Be $False
            # $Actual = Invoke-MuGitAddCommitPush -computername $ComputerName
            #    $Actual.length | Should -BeGreaterThan 22
            #     $Actual.length | Should -BeLessThan 222

        }
    }

    Context invoke-MuGitDiff {

        It "Does not fall over" {

            {Invoke-MuGitDiff} | Should -Not Throw

        }

    }

    Context Invoke-MuGitDiffAddCommit {

        It "Does not fall over" {

            {Invoke-MuGitDiffAddCommit } | Should -Not Throw

        }
    }

    Context Select-MuColumns {

        It "returns a sensible number of objects" {
            $Actual = get-childitem | Select-MuColumns
            $Actual.length | Should -BeGreaterThan 3
            $Actual.length | Should -BeLessThan 10
        }
    }


    Context Test-MuNetConnectionOverTime {

        It "returns a sensible number of objects" {
            $Actual = Test-MuNetConnectionOverTime -computername $ComputerName -count 2
            $Actual.length | Should -Be 1
        }
    }

    Context test-MuServerIsUp {

        It "returns a sensible number of objects" {
            $Actual = test-MuServerIsUp -computername $ComputerName
            $Actual.length | Should -BeGreaterThan 1
        }
    }
}