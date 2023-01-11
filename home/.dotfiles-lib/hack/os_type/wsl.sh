#!/usr/bin/env bash

export LANG=en_US.UTF-8

alias vagrant=/mnt/c/HashiCorp/Vagrant/bin/vagrant.exe

if ! command -v realpath >/dev/null 2>&1; then
    echo 'Warning: dotfiles: Please install realpath for git to handle file mode correctly.' >&2
else
    git() {
        if [[ "$(realpath "$PWD")" == /mnt/* ]]; then
            command git -c core.filemode=false "$@"
        else
            command git "$@"
        fi
    }
fi
