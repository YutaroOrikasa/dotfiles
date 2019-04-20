
alias ls='ls -G'

alias compinit='compinit -u'

export PATH=~/.usr/mac/bin:"$PATH"

git () {
    if [[ "$1" == push ]];then
        if command git config --list | grep credential.helper=osxkeychain >/dev/null;then
            (
                echo 'WARNING'
                echo 'credential.helper=osxkeychain is set.'
                echo 'Your credential helper will not work.'
                echo 'You have to unsed OSX default credential.helper.'
                command git config --show-origin --list | grep credential.helper
            ) >&2
        fi
    fi
    command git "$@"
}
