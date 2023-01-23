#!/usr/bin/env bash

export LANG=en_US.UTF-8

export PATH="$HOME/.usr/wsl/bin:$PATH"

git() {
        if [[ "$(wslpath -m "$PWD")" =~ [A-Z]:/.*|//.* ]]; then
            command git -c core.filemode=false "$@"
        else
            command git "$@"
        fi
    }

unalias open

open() {
    explorer.exe "$(wslpath -w "$1")"
}
