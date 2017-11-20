#!/bin/bash

set -xv

cd ~

ln -s $(ls -1d dotfiles/.* | grep -v -E '(dotfiles/.|dotfiles/..|dotfiles/.git|dotfiles/.gitignore)$') ./
