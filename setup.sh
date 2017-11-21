#!/bin/bash

set -xv

cd ~/dotfiles

case "$1" in
    -r|--replace)
        mkdir ~/old_dotfiles || exit
        for file in $(ls -1d .* | grep -v -E '(\.|\.\.|\.git|\.gitignore)$');do
            mv ~/"$file" ~/old_dotfiles
        done
         ;;
esac

cd ~
ln -s $(ls -1d dotfiles/.* | grep -v -E 'dotfiles/(\.|\.\.|\.git|\.gitignore)$') ~/
