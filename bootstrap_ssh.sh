#!/bin/bash
set -xv

cd ~

remote="$1"
shift

rm -rf bootstrap.tmp
mkdir bootstrap.tmp
chmod 700 bootstrap.tmp

mkdir bootstrap.tmp/ssh
cp -a .ssh/config bootstrap.tmp/ssh

cp -a dotfiles bootstrap.tmp/.

mkdir bootstrap.tmp/stuff
[ $# -ge 1 ] && cp -a "$@" bootstrap.tmp/stuff

ssh-copy-id -i .ssh/id_rsa "$remote"
tar -c bootstrap.tmp/ | gzip - | ssh "$remote" 'tar -xf -'

ssh "$remote" -t '
cd
shopt -s dotglob
rm -rf bootstrap.tmp
mkdir .ssh
chmod 700 .ssh
cp -ai bootstrap.tmp/ssh/* .ssh
cp -a bootstrap.tmp/dotfiles ./.
cp -ai bootstrap.tmp/stuff/* ./.
dotfiles/setup.sh
if which zsh >/dev/null;then zsh;else bash; fi
'
