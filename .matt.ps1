$OriginalLocation = Get-Location
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
    write-debug "Doing the Linux Home"
    $HomeMatt = '/home/matt'
    
    $PowershellFolder = join-path $HomeMatt "powershell"
    write-debug  "<`$env:PSModulePath $env:PSModulePath>"
    
    $env:PSModulePath = $env:PSModulePath + ":/home/matt/powershell/modules"
    write-debug  "<`$env:PSModulePath $env:PSModulePath>"
    
    $ENV:PAth = $Env:Path + ";/home/matt/sdcard/hugo/bin"
    $Images = "$HomeMatt/salisburyandstonehenge.net/static/images"
    $Sas = "$HomeMatt/salisburyandstonehenge.net"
  
}
else 
{
    set-executionpolicy bypass -Scope Process
    
    
    $HomeMatt = "c:\matt"
    $ENv:Home = $HomeMatt

    $PowershellFolder = join-path "c:" "powershell"

    if (test-path c:\matt\local\set-LocalEnvironment.ps1)
    {
        . c:\matt\local\set-LocalEnvironment.ps1
    }
    if (test-path 'C:\Program Files\Vim\vim80\gvim.exe')
    {
        set-alias gvim 'C:\Program Files\Vim\vim80\gvim.exe'
    }
    else
    {
        set-alias gvim 'C:\Program Files (x86)\Vim\vim80\gvim.exe'
    }

    $Modules = join-path $PowershellFolder "modules"

    $env:PSModulePath = "$env:PSModulePath;$Modules;$PowershellFolder/work_in_progress"
    $env:Path = "$env:Path;C:\Users\matty\AppData\Local\Programs\Git"

    
    import-module WindowsStuff
    import-module SqlStuff
        
	
}




if ($WhereAmI -ne $WinWork)
{
    function cdhugo { cd $(Join-Path $HomeMatt "salisburyandstonehenge.net") }
    function cdodt { cd $(Join-Path $HomeMatt "salisburyandstonehenge.net/content/on-this-day") }
    function cdpic { cd $(Join-Path $HomeMatt "salisburyandstonehenge.net/static/images") }
    set-alias cdotd cdodt
       

    <#
        function runhugo {cd /home/matt/salisburyandstonehenge.net ; d:/hugo/bin/hugo server -w  --renderToDisk --theme hyde}
        function rundocs {cd /home/matt/sdcard/hugo/sites/docs ; d:/hugo/bin/hugo server -w -v --renderToDisk -p 1314}
        set-alias rundoc rundocs
    #>
    #  $OLD = "/home/matt/sdcard/hugo/sites/example.com/content/on-this-day"
    $OTD = join-path $HomeMatt "salisburyandstonehenge.net/content/on-this-day"

    $R="c:\matt\RescuedContent"
    $RR="$R\roadnames"
    $Rb="$R\books"
    $Rg="$R\general"
    $Rp="$R\photos"
    $Rn="$R\salisbury-news"
    $Rs="$R\stonehenge-2"
    $Rt="$R\thingstodo"
    $Images = "C:\matt\salisburyandstonehenge.net\static\images"
}


if (!($PowershellFolder))
{
    $PowershellFolder = "C:\Users\$Username\Documents\windowspowershell"
}
cd $PowershellFolder

$Modules = join-path $PowershellFolder "modules"
write-debug  "<`$env:PSModulePath $env:PSModulePath>"
    
$Scripts = join-path $PowershellFolder "Scripts"
$Functions = join-path $PowershellFolder "Functions"
set-alias ebook cdbook

function cdmod {cd $Modules}
function cdfun {cd $Functions}
function cdscripts {cd $scripts}
function cdwip {cd $PowershellFolder/work_in_progress}
function cdph {cd $PowershellFolder/modules/PowerHugo}
function cdbook {cd C:/Users/$Username/Documents/a-unix-persons-guide-to-powershell}

$FunctionsFolder = "$PowershellFolder/functions"

$env:path = $env:path + ";" + $PowershellFolder + ";" + $FunctionsFolder
write-debug  "4: <`$env:PSModulePath $env:PSModulePath>"


$VerbosePreference = "Continue"



write-verbose "About to load functions"
foreach ($FUNC in $(select-string Autoload $FunctionsFolder/*.ps1))
{

  $FunctionToAutoload = $Func.Path
  . $FunctionToAutoload
}
write-debug  "5: <`$env:PSModulePath $env:PSModulePath>"

write-verbose "About to non-githubbed functions functions"
foreach ($FUNC in $(select-string Autoload $UnGithubbedFunctionsFolder/*.ps1))
{

  $FunctionToAutoload = $Func.Path
  . $FunctionToAutoload
}
write-debug  "6: <`$env:PSModulePath $env:PSModulePath>"

function select-StringsFromCode {
<#
.SYNOPSIS
Searches for specified text in functions folder

This function is autoloaded
#>
param ($SearchString)
    select-string $SearchString $FunctionsFolder/*.ps1 | select path, line
    select-string $SearchString $Modules/*.psm1 | select path, line
    select-string $SearchString $UnGithubbedFunctionsFolder/*.ps1 | select path, line

}

set-alias sfs select-StringsFromCode
set-alias gfs sfs

$DEBUGPREFERENCE = "SilentlyContinue"
$VerbosePreference = "SilentlyContinue"

write-debug  "7: <`$env:PSModulePath $env:PSModulePath>"

Import-Module z
import-module PersonalStuff
import-module -force PSReadLine

function prompt { [string]$x=$pwd
    $x = $x -replace '/home/matt',''
    $x = $x -replace '/sdcard',''
    $x = $x -replace 'c:\\matt\\salisburyandstonehenge.net','s.net'
    $x = $x -replace '/salisburyandstonehenge.net','s.net'
    $x = $x -replace 'content\\roadnames','roads'
    $x = $x -replace '/mattypenny.net','s.net'
    $x = $x -replace '/powershell/modules/PowerHugo','PH'
    $x = $x -replace 'c:\\mattypenny.net\\','s.net'
    $x = $x -replace 'C:\\powershell\\modules\\',''
    $x = $x -replace 'PowerHugo','PH'
    $x = $x -replace 'ConvertWordpressXmlToHugo','Conv'
    "$x >"   
}

$Roads = "c:\salisburyandstonehenge.net\content\roadnames"
        $Conv = 'C:\powershell\modules\ConvertWordpressXmlToHugo'
        $HistoryFile = Join-Path $PowershellFolder -ChildPath 'history'
        
        $HistoryFile = Join-Path $HistoryFile -ChildPath 'ExportedHistory.xml'
function export-history {
    Get-History | Export-Clixml $HistoryFile 
}

set-alias ehh export-history
set-alias eh export-history
set-alias gh export-history

set-alias impo import-module

Add-History -InputObject (Import-Clixml -Path $HistoryFile)

cd $OriginalLocation
