function Get-ListOfFunctionsDefinedInFolderFiles {
<#
.SYNOPSIS
    Get a list of functions that need to be checked
#>
    [CmdletBinding()]
    param (
        $Folder = $(get-location)
    )
    
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
    
    write-startfunction

    $Files = get-childitem -include "*.ps1","*.psm1" -Exclude *tests.ps1,*git* -recurse -path "$Folder"

    foreach ($F in $Files) {
         
        $Fullname = $F.Fullname
        write-dbg "Processing `$Fullname: <$Fullname>"

        $FunctionLines = select-string '^function ' $FullName

        foreach ($F in $FunctionLines) {
            $Line = $F.Line
            write-dbg "`$Line: <$Line>"

            $Function = $Line.split(' ')[1]

            $Function = $Function.TrimEnd('{')

            write-dbg "`$Function: <$Function>"

            $Function
        }

    }
    
    
    write-endfunction
    
    
}