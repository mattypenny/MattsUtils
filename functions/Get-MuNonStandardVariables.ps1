function Get-MuNonStandardVariables {
    <#
.SYNOPSIS
   show the interesting variables...mainly for use in debug
#>
    [CmdletBinding()]
    param (
   
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    $VariablesCsv = @"
"Name"
"?"
"^"
"$"
"All"
"args"
"ConfirmPreference"
"VariablesCsv"
"DebugPreference"
"EnabledExperimentalFeatures"
"Error"
"ErrorActionPreference"
"ErrorView"
"ExecutionContext"
"F"
"false"
"foreach",
"FormatEnumerationLimit"
"Functions"
"FunctionsFolder"
"history"
"HOME"
"HomeMatt"
"Host"
"imported"
"InformationPreference"
"input"
"IsCoreCLR"
"IsLinux"
"IsMacOS"
"IsWindows"
"LASTEXITCODE"
"LinuxHome"
"MaximumHistoryCount"
"Modules"
"MyInvocation"
"NestedPromptLevel"
"null",
"OutputEncoding"
"PID"
"PowershellFolder"
"PROFILE"
"ProgressPreference"
"PSBoundParameters"
"PSCmdlet"
"PSCommandPath"
"PSCulture"
"PSDebugContext"
"PSDefaultParameterValues"
"PSEmailServer"
"PSGetPath"
"PSHOME"
"PSNativeCommandArgumentPassing"
"PSNativeCommandUseErrorActionPreference"
"PSSessionApplicationName"
"PSSessionConfigurationName"
"PSSessionOption"
"PSStyle"
"PSUICulture"
"PSVersionTable"
"PWD"
"Scripts"
"ShellId"
"StackTrace"
"StandardVariables"
"true"
"Username"
"VerbosePreference"
"WarningPreference"
"WhatIfPreference"
"WhereAmI"
"WinHome"
"WinWork"

"@
   
    $StandardVariables = $VariablesCsv | ConvertFrom-Csv

    Get-Variable | 
    Where-Object { $_.Name -notin $StandardVariables.Name } | 
    Select-Object Name, Value

    write-endfunction
   
   
}
set-alias gnsv Get-MuNonStandardVariables