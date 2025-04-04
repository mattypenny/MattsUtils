Describe "everything is pushed" {

    It "git status --porcelain must return nothing" {

        [int]$UnPushedCount = $(git status --porcelain | measure-object).count

        $UnPushedCount | Should -Be 0

    }

}

