foreach ($F in $(get-childitem  ./functions)) {
    . $F.fullname
}
