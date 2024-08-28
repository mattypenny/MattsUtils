function get-MuShare {
Param ( [String] $MyServer = ".")

  Get-CimInstance win32_share -computer $MyServer | sort-object name

}
set-alias sshare get-Mushare
