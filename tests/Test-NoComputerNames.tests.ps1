param (
    $Filename = "*",
    [boolean]$Detail = $False,
    [boolean]$Recurse = $False
)

Describe "ComputerName" {

    . C:\devsoftware\powershell\scripts\StandardPesterTests\tests\HelperFunctions.ps1

    $DataFolder = $Env:PSParametersFolder
    $CSDataFolder = "$DataFolder\Checksystems"
    $CsGeneralParametersFile = "$CSDataFolder\CSGeneralParameters.csv"

    $PesterOutputFolder = "c:\temp\PesterOutput"
    $OutputFolder = "c:\temp\CheckSystems"

    $ThrowAwayTheOutput = mkdir -force $PesterOutputFolder
    $ThrowAwayTheOutput = mkdir -force $OutputFolder

    $ComputerNameStrings = import-csv $DataFolder\ComputerNameStrings.csv

    if ($Recurse) {
        $Files = Get-ChildItem $Filename -recurse -File |
            Where-Object fullname -notlike "*\.git\*" |
            Where-Object Extension -ne '.bat'
    } else {
        $Files = Get-ChildItem $Filename -File |
            Where-Object fullname -notlike "*\.git\*" |
            Where-Object Extension -ne '.bat'
    }

    $FilesAsHashTable = ConvertTo-HashtableFromPsCustomObject -psCustomObject $Files

    It "File \<Fullname> must have no mention of any servers" -TestCases $FilesAsHashTable {
        param ($FullName)

        . C:\devsoftware\powershell\scripts\StandardPesterTests\tests\HelperFunctions.ps1

        $FileContentsIncludeComputerNames = test-FileContentsIncludeComputerNames -ComputerNameString $ComputerNameString -Fullname $Fullname

        $FileContentsIncludeComputerNames | Should -Be $False

    }
}
