$Username = $Env:UserName



[string]$LinuxHome = "LinuxHome"

[string]$WinHome = "WinHome"

[string]$WinWork = "WinWork"



[string][ValidateSet("LinuxHome", "WinHome", "WinWork")]$WhereAmI = "LinuxHome"







if ($IsLinux)
{

    $WhereAmI = $LinuxHome

}

else
{

    if ($Env:ComputerName -like "P*")
    {

        $WhereAmI = $WinWork

    }

    else
    {

        $WhereAmI = $WinHome

    }

}

# Set up stuff specific to this particular PC or environment



if ($WhereAmI -eq $LinuxHome)
{

    $HomeMatt = '/home/matt'



    $PowershellFolder = join-path $HomeMatt "powershell"

    $env:PSModulePath = $env:PSModulePath + ":/home/matt/powershell/modules"

    $ENV:PAth = $Env:Path + ";/home/matt/sdcard/hugo/bin"

    $Images = "$HomeMatt/salisburyandstonehenge.net/static/images"

    $Sas = "$HomeMatt/salisburyandstonehenge.net"



}

else
{

    set-executionpolicy bypass -Scope Process





    $HomeMatt = "c:\matt"



    if ($PSVersionTable.PSVersion.Major -lt 7) {

        $PowershellFolder = join-path "c:" "powershell"

    }
    else {

        $PowershellFolder = join-path "c:" "devsoftware"

        $PowershellFolder = join-path $PowershellFolder "powershell"

    }



    if (test-path c:\devsoftware\powershell\set-LocalEnvironment.ps1)
    {

        . c:\devsoftware\powershell\set-LocalEnvironment.ps1

    }

    if (test-path 'C:\Program Files\Vim\vim74\gvim.exe')
    {

        set-alias gvim 'C:\Program Files\Vim\vim74\gvim.exe'

    }

    else
    {

        set-alias gvim 'C:\Program Files (x86)\Vim\vim74\gvim.exe'

    }





}









if ($WhereAmI -ne $WinWork)
{







    <#

        function runhugo {cd /home/matt/salisburyandstonehenge.net ; d:/hugo/bin/hugo server -w  --renderToDisk --theme hyde}

        function rundocs {cd /home/matt/sdcard/hugo/sites/docs ; d:/hugo/bin/hugo server -w -v --renderToDisk -p 1314}

        set-alias rundoc rundocs

    #>

    #  $OLD = "/home/matt/sdcard/hugo/sites/example.com/content/on-this-day"


}





if (!($PowershellFolder))
{

    $PowershellFolder = "C:\Users\$Username\Documents\windowspowershell"

}




$Modules = join-path $PowershellFolder "modules"

$env:PSModulePath = "$env:PSModulePath;c:\devsoftware\powershell\modules"

$env:PSModulePath = "$Modules;$env:PSModulePath"

if ($PSVersionTable.PSVersion.Major -ge 7) {

    $env:PSModulePath = "$env:PSModulePath;c:\powershell\modules"

}

$Scripts = join-path $PowershellFolder "Scripts"

$Functions = join-path $PowershellFolder "Functions"

set-alias ebook cdbook



function cdmod { cd $Modules }

function cdfun { cd $Functions }

function cdscripts { cd $scripts }

function cdwip { cd $PowershellFolder/work_in_progress }

function cdph { cd $PowershellFolder/modules/poshhugo }

function cdbook { cd C:/Users/$Username/Documents/a-unix-persons-guide-to-powershell }



$FunctionsFolder = "c:\powershell\workfunctions"







$env:path = $env:path + ";" + $PowershellFolder + ";" + $FunctionsFolder



$VerbosePreference = "Continue"







write-verbose "About to load functions"




function select-StringsFromCode {

    <#

.SYNOPSIS

Searches for specified text in functions folder



This function is autoloaded

#>

    param ($SearchString)

    select-string $SearchString $FunctionsFolder/*.ps1 | select path, line

    select-string $SearchString $Modules/*.psm1 | select path, line



}



set-alias sfs select-StringsFromCode

set-alias gfs sfs

set-alias backup-mystuff C:\powershell\scripts\backup-FoldersAndFiles\Backup-FoldersAndFiles.ps1



$DEBUGPREFERENCE = "SilentlyContinue"

$VerbosePreference = "SilentlyContinue"





Import-Module z

# import-module PersonalStuff

# import-module WindowsStuff

import-module MattsUtils

import-module -force PSReadLine



function prompt {
    [string]$x = $pwd

    $x = $x -replace '/home/matt', ''

    $x = $x -replace '/sdcard', ''

    $x = $x -replace '/salisburyandstonehenge.net', 's.net'

    $x = $x -replace '/mattypenny.net', 's.net'

    $x = $x -replace 'C:\\powershell\\modules\\', ''

    $x = $x -replace 'C:\\devsoftware\\powershell\\scripts\\', ''

    $x = $x -replace 'C:\\devsoftware\\powershell\\modules\\', ''





    if (Test-Path Variable:\PSDebugContext) {

        write-host -foregroundcolor DarkRed "$x [DBG]: "
    }

    else {

        $LastCommand = get-history -Count 1



        $LastCommandExecutionTime = $LastCommand.EndExecutionTime - $LastCommand.StartExecutionTime



        [int]$Milliseconds = $LastCommandExecutionTime.TotalMilliseconds



        $Seconds = [math]::Round($Milliseconds / 1000 , 2)



        "$(Get-Date -format "HH:mm") [$Seconds] $x >"

    }





}





<#

Update-TypeData -TypeName System.IO.FileInfo -MemberName FileSize -MemberType ScriptProperty -Value {



    switch($this.length) {

               { $_ -gt 1gb }

                      { "{0:n2} GB" -f ($_ / 1gb) }

               { $_ -gt 1mb }

                      { "{0:n2} MB " -f ($_ / 1mb) }

               { $_ -gt 1kb }

                      { "{0:n2} KB " -f ($_ / 1Kb) }

               default

                      { "{0} B " -f $_}

             }



} -DefaultDisplayPropertySet Mode,LastWriteTime,FileSize,Name

#>



Set-PSReadlineOption -HistorySavePath C:\matt\local\savepath.txt

Set-PSReadlineOption -EditMode vi -BellStyle None


import-module Pester
$PesterPreference = [PesterConfiguration]::Default

$PesterPreference.Output.Verbosity = 'Detailed'

set-alias gvim gvim.bat
