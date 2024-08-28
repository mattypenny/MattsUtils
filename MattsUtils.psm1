foreach ($f in $(get-childitem C:\DevSoftware\powershell\modules\MattsUtils\functions\*.ps1)) {
    . $f
}
