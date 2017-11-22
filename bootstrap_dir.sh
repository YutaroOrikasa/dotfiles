#!/bin/bash
set -xv

mkdir "$1"
cd "$1"
dir="$(pwd)"
shift

cd ~


rm -rf bootstrap.tmp
mkdir bootstrap.tmp
chmod 700 bootstrap.tmp

mkdir bootstrap.tmp/ssh
cp -a .ssh/* bootstrap.tmp/ssh

cp -a dotfiles bootstrap.tmp/.

mkdir bootstrap.tmp/stuff
[ $# -ge 1 ] && cp -a "$@" bootstrap.tmp/stuff


3< <(tar -c bootstrap.tmp/) HOME="$dir" bash -c '
cd
shopt -s dotglob
rm -rf bootstrap.tmp
tar -xf - <&3
mkdir .ssh
chmod 700 .ssh
cp -ai bootstrap.tmp/ssh/* .ssh
cp -a bootstrap.tmp/dotfiles ./.
cp -ai bootstrap.tmp/stuff/* ./.
dotfiles/setup.sh
if which zsh >/dev/null;then zsh;else bash; fi
'

