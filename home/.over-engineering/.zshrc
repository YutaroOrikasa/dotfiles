



function cheatsheet {
    less ~/.cheatsheet/"$1"
}

function _cheatsheet {
    _files -W ~/.cheatsheet -g "*[^~]"
}

compdef _cheatsheet cheatsheet
