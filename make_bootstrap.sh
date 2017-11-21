#!/bin/bash

# ./bootstrap.sh [arg]...
# arg: path to file or dir you want to stuff to bootstrap.tar

set -vx

set -e
cd ~

rm -rf bootstrap.tmp

mkdir bootstrap.tmp
cp -a .ssh bootstrap.tmp

for path in "$@";do
    cp -a "$path" bootstrap.tmp
done

cat > bootstrap.tmp/bootstrap.sh <<EOF
cd ~
git clone 'ssh://dotfiles-git-server/~/dotfiles-bare'
dotfiles/setup.sh

EOF

chmod a+x bootstrap.tmp/bootstrap.sh

tar -c bootstrap.tmp | gzip - > bootstrap.tar.gz

cat > bootstrap.sh <<EOF
cd ~
tar -xf bootstrap.tar.gz
mv bootstrap.tmp/.ssh .
echo 'please execute ./bootstrap.tmp/bootstrap.sh'

EOF

chmod a+x bootstrap.sh

set +xv

cat <<EOF


created: 
    bootstrap.sh
    bootstrap.tar.gz
copy them to new home dir and execute bootstrap.sh
EOF
