function ConvertTo-HashtableFromPsCustomObject { 
<#
.Synopsis
   Convert to a hash table from an object
.DESCRIPTION
   Can be used to turn an object into a test case

   From: https://blogs.msdn.microsoft.com/timid/2013/03/05/converting-pscustomobject-tofrom-hashtables/
.EXAMPLE
   $ChildItems = get-childitem
   ConvertTo-HashtableFromPsCustomObject -psCustomObject $ChildItems
#>
    param ( 
        [Parameter(  
            Position = 0,   
            Mandatory = $False,   
            ValueFromPipeline = $true,  
            ValueFromPipelineByPropertyName = $true  
        )] [object[]]$psCustomObject 
    ); 
    
    process { 
        if ($psCustomObject) {
            foreach ($myPsObject in $psCustomObject) { 
                $output = @{}; 
                $myPsObject | Get-Member -MemberType *Property | % { 
                    $output.($_.name) = $myPsObject.($_.name); 
                } 
                $output; 
            } 
        }
        else {
            $output = @{};
            $output 
        }       
    } 
}

function test-FileContentsIncludeComputerNames {
<#
.SYNOPSIS
    xx
#>
    [CmdletBinding()]
    param (
        [string[]]$ComputerNameString,
        [string]$FullName
    )
    
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
    
    write-startfunction

    # write-host -ForegroundColor DarkYellow "    Testing $Fullname"
    $Result = $False
    
    foreach ($C in $ComputerNameStrings) {
        [string]$ComputerNameString = $C.ComputerNameString

        $Hits = select-string $ComputerNameString -Path $FullName

        if ($Hits) {
            foreach ($L in $Hits) {
                $Line = $L.Line
                $LineNumber = $L.LineNumber

                write-host -ForegroundColor DarkYellow "      $FullName`:$LineNumber`:$Line"

                $Result = $True
            }
        } else {
        }

    }

    if (!($Result)) {
            # write-host -ForegroundColor DarkYellow "      $Fullname`:OK" 
    }
    
    write-endfunction
    
    return $Result

}

function test-FileNameIncludesComputerNames {
<#
.SYNOPSIS
    xx
#>
    [CmdletBinding()]
    param (
    
    )
    
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
    
    write-startfunction
    
        if ($FullName -like "*$ComputerNameString*") {

            $FullName | Should Be "No computername in filename"
        }
    
    
    write-endfunction
    
    
}
