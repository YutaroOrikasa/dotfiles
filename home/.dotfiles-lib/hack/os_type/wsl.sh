#!/usr/bin/env bash

export LANG=en_US.UTF-8

export PATH="$HOME/.usr/wsl/bin:$PATH"

unalias open

open() {
    explorer.exe "$(wslpath -w "$1")"
}
