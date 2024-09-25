param (
    $Filename = "*",
    [boolean]$Detail = $False,
    [boolean]$Recurse = $False
)

Describe "ComputerName" {

    BeforeAll {
        . $Env:PsRoot\scripts\StandardPesterTests\tests\HelperFunctions.ps1

        $DataFolder = $Env:PSParametersFolder

        $PesterOutputFolder = "c:\temp\PesterOutput"
        $OutputFolder = "c:\temp\PesterOutput"

        $ThrowAwayTheOutput = mkdir -Force $PesterOutputFolder
        $ThrowAwayTheOutput = mkdir -Force $OutputFolder

        $ComputerNameStrings = Import-Csv $DataFolder\ComputerNameStrings.csv
        write-dbg "`$ComputerNameStrings count: <$($ComputerNameStrings.Length)>"


    }

    if ($Recurse) {
        $Files = Get-ChildItem $Filename -force -Recurse -File |
            # Where-Object fullname -NotLike "*\.git\*" |
            Where-Object Extension -NE '.bat'
    }
    else {
        $Files = Get-ChildItem $Filename -File |
            Where-Object fullname -NotLike "*\.git\*" |
            Where-Object Extension -NE '.bat'
    }

    $FilesAsHashTable = ConvertTo-HashtableFromPsCustomObject -psCustomObject $Files

    It "File \<Fullname> must have no mention of any servers" -TestCases $FilesAsHashTable {
        param ($FullName)

        . $Env:PsRoot\scripts\StandardPesterTests\tests\HelperFunctions.ps1

        $FileContentsIncludeComputerNames = test-FileContentsIncludeComputerNames -ComputerNameString $ComputerNameString -Fullname $Fullname

        $FileContentsIncludeComputerNames | Should -Be $False

    }
}
